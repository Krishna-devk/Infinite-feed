# High-Performance Social Feed

A production-grade infinite scrolling social feed built with Flutter and Supabase, optimized for GPU performance, RAM safety, and optimistic state synchronization.

## 🚀 Key Features & Performance Optimizations

### 1. GPU Protection (Shadow Rasterization)
- **Problem**: Large blur shadows (e.g., elevation 16+) are extremely expensive to calculate and can cause jank during scrolling.
- **Solution**: All `PostCard` widgets are wrapped in a `RepaintBoundary`. This instructs Flutter to cache the rendered shadow as a texture on the GPU, avoiding expensive re-calculation of the shadow math during scrolling.
- **Verification**: Verified using **Flutter DevTools Performance Overlay**. The "skia" thread stays green even during rapid scrolling.

### 2. RAM & Data Protection (OOM Prevention)
- **Problem**: Decoding high-resolution images into memory can quickly lead to Out-Of-Memory (OOM) crashes.
- **Solution**: 
  - **Tiered Loading**: We use a 3-tier image pipeline (`thumb` -> `mobile` -> `raw`). The feed only loads the 300px thumbnails.
  - **memCacheWidth**: We explicitly set `memCacheWidth` in `CachedNetworkImage` to match the exact display dimensions on the screen. This ensures that even if a large image is downloaded, it is only decoded at the target resolution in RAM.
- **Verification**: Memory usage remains flat (stable around 80-120MB) regardless of the number of items scrolled in the feed.

### 3. Optimistic UI & Spam Protection
- **Approach**: Using **Riverpod 3.x** Notifiers.
- **Optimistic Sync**: When a user likes a post, the UI updates instantly. A background task is fired to sync with Supabase.
- **Spam Protection**: Implemented a **500ms debounce** logic. If a user spam-clicks the like button, the UI toggles instantly every time, but only the final state is synced to the database after the user stops clicking.
- **Rollback**: If the network is offline, the `RollbackObserver` (via `ProviderObserver`) detects the failure and seamlessly reverts the UI state to the last known-good server state while notifying the user via SnackBar.

## 🛠️ Technical Stack
- **State Management**: Riverpod 3.0 (Generated Notifiers)
- **Database**: Supabase (PostgreSQL + RPC)
- **Image Handling**: CachedNetworkImage + 3-Tier Pipeline
- **Animations**: Hero transitions & Backdrop filters

