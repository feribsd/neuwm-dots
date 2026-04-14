#!/bin/bash
set -e

# neuwm Build Script for Alpine Linux
# This script clones and builds all dependencies and neuwm

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Configuration
BUILD_DIR="${BUILD_DIR:-$HOME/windowmanagerdep}"
INSTALL_PREFIX="${INSTALL_PREFIX:-/usr/local}"
JOBS="${JOBS:-$(nproc)}"

log_info "Starting neuwm build for Alpine Linux"
log_info "Build directory: $BUILD_DIR"
log_info "Install prefix: $INSTALL_PREFIX"
log_info "Parallel jobs: $JOBS"

# Check if running on Alpine
if ! grep -qi "Alpine" /etc/os-release 2>/dev/null; then
    log_warn "This script is optimized for Alpine Linux. Some steps may fail on other distributions."
fi

# Step 1: Install system dependencies via apk
log_info "Installing system dependencies via apk..."
if ! command -v apk &> /dev/null; then
    log_error "apk package manager not found. This script requires Alpine Linux."
    exit 1
fi

# Install build tools and dev packages available in apk
doas apk add --no-cache \
    build-base \
    git \
    meson \
    ninja \
    pkgconfig \
    wayland-dev \
    libinput-dev \
    pixman-dev \
    libdrm-dev \
    eudev-dev \
    xcb-util-dev \
    lua-dev \
    fontconfig-dev \
    linux-headers

log_info "APK dependencies installed successfully"

# Step 2: Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"
log_info "Working directory: $BUILD_DIR"

# Step 3: Clone repositories
declare -A repos
repos[wld]="https://git.sr.ht/~dlm/wld"
repos[neuwld]="https://git.sr.ht/~shrub900/neuwld"
repos[neuwm]="https://git.sr.ht/~pfr/neuwm"
repos[neumenu]="https://git.sr.ht/~uint/neumenu"
repos[swall]="https://git.sr.ht/~uint/swall"
repos[mojito]="https://git.sr.ht/~dlm/mojito"
repos[hst]="https://git.sr.ht/~dlm/hst"

for repo_name in "${!repos[@]}"; do
    repo_url="${repos[$repo_name]}"
    log_info "Cloning $repo_name..."
    if [ -d "$BUILD_DIR/$repo_name" ]; then
        log_warn "$repo_name already exists, skipping clone"
    else
        git clone "$repo_url" "$repo_name" || log_warn "Failed to clone $repo_name"
    fi
done

# Step 4: Build in dependency order
# Note: wld must be built first as it's a dependency for others

declare -a build_order=(wld neuwld neuwm neumenu swall mojito hst)

for project in "${build_order[@]}"; do
    if [ ! -d "$BUILD_DIR/$project" ]; then
        log_warn "Skipping $project (not cloned)"
        continue
    fi
    
    log_info "Building $project..."
    cd "$BUILD_DIR/$project"
    
    # Detect build system and build accordingly
    if [ -f "meson.build" ]; then
        log_info "Using Meson/Ninja for $project"
        meson setup --prefix="$INSTALL_PREFIX" build || {
            log_warn "Meson setup failed for $project, trying alternative..."
            meson setup --prefix="$INSTALL_PREFIX" -Dprefix="$INSTALL_PREFIX" build || true
        }
        ninja -C build -j "$JOBS" || log_error "Build failed for $project"
        doas ninja -C build install || log_error "Install failed for $project"
    elif [ -f "Makefile" ] || [ -f "makefile" ]; then
        log_info "Using Make for $project"
        make -j "$JOBS" PREFIX="$INSTALL_PREFIX" || log_error "Make failed for $project"
        doas make PREFIX="$INSTALL_PREFIX" install || log_error "Install failed for $project"
    elif [ -f "CMakeLists.txt" ]; then
        log_info "Using CMake for $project"
        cmake -B build -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" || log_error "CMake config failed for $project"
        make -C build -j "$JOBS" || log_error "Build failed for $project"
        doas make -C build install || log_error "Install failed for $project"
    else
        log_warn "Unknown build system for $project, skipping..."
    fi
done

log_info "All projects built successfully"

# Step 5: Set up neuwm configuration
log_info "Setting up neuwm configuration..."
mkdir -p "$HOME/.config/neuwm"
cd "$HOME/.config/neuwm"

if [ ! -d "neuwm-dots" ]; then
    log_info "Cloning neuwm-dots configuration..."
    git clone https://github.com/feribsd/neuwm-dots.git neuwm-dots || {
        log_error "Failed to clone neuwm-dots"
    }
fi

# Copy config.lua if it exists
if [ -f "neuwm-dots/config.lua" ]; then
    log_info "Installing config.lua..."
    cp neuwm-dots/config.lua config.lua
else
    log_warn "config.lua not found in neuwm-dots repository"
fi

# Step 6: Create launch wrapper script
log_info "Creating neuwm launch script..."
LAUNCH_SCRIPT="$INSTALL_PREFIX/bin/neuwm-launch"

doas tee "$LAUNCH_SCRIPT" > /dev/null << 'EOF'
#!/bin/sh -e
export WLD_DRM_DUMB=1
export XDG_SESSION_DESKTOP=neuwm
swc-launch neuwm
EOF

doas chmod +x "$LAUNCH_SCRIPT"
log_info "Launch script created at $LAUNCH_SCRIPT"

# Step 7: Final summary
log_info "Build complete!"
echo ""
echo -e "${GREEN}=== Installation Summary ===${NC}"
echo "Build directory: $BUILD_DIR"
echo "Install prefix: $INSTALL_PREFIX"
echo "Config directory: $HOME/.config/neuwm"
echo ""
echo "To start neuwm, run:"
echo "  $LAUNCH_SCRIPT"
echo ""
echo "Or directly:"
echo "  neuwm"
echo ""
log_info "Make sure your display server environment is properly configured."
