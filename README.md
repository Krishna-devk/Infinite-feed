# High-Performance Social Feed

A production-grade infinite scrolling social feed built with Flutter and Supabase, optimized for GPU performance, RAM safety, and optimistic state synchronization.

## 🚀 State Management Approach (Riverpod)

We utilize a **Centralized Store Pattern** to manage the feed's state, ensuring a "Single Source of Truth":

- **PostsStore**: A global `Map<String, PostEntity>` notifier that acts as the canonical source for all post data. This ensures that if a post is updated (e.g., liked), the change propagates instantly to all UI instances of that post across the feed and detail screens.
- **Similarity Broadcasting**: To handle the circular feed requirement where identical posts may repeat, the `PostsStore` automatically synchronizes all posts sharing the same `mediaThumbUrl`. Liking one instance updates all duplicates in the scroll sequence.
- **Optimistic UI with Debouncing**: Interactions update the UI instantly. A **500ms debounce** timer aggregates rapid clicks (handling "Spam Clickers") into a single final Supabase RPC call.
- **Resilient Rollback**: We use a snapshot-based rollback system. If a background sync fails, the `RollbackObserver` (a `ProviderObserver`) detects the error, reverts the state to the pre-click snapshot, and notifies the user via a floating SnackBar.

## ⚡ Performance Optimizations & Verification

### 1. GPU Protection (RepaintBoundary)
- **Strategy**: Large blur shadows and glassmorphic effects are GPU-intensive. We wrap each `PostCard` in a `RepaintBoundary` to isolate these layers.
- **Verification**: Verified using **Flutter DevTools "Highlight Repaints"**. During scrolling, only the new items entering the viewport repaint; existing cards remain static textures on the GPU, eliminating rasterization jank.

### 2. RAM & Data Protection (memCacheWidth)
- **Strategy**: To prevent OOM (Out of Memory) crashes, we use `memCacheWidth` in `CachedNetworkImage`.
- **Logic**: We calculate the target width as `screenWidth * devicePixelRatio`. This ensures the decoded image in RAM exactly matches the physical display size, regardless of the source image resolution.
- **Verification**: Verified using the **DevTools Memory Profiler**. We confirmed that the heap growth is linear and strictly capped by the screen dimensions, even when scrolling through hundreds of images.

### 3. Tiered Loading
- **Strategy**: Images are loaded in three tiers: `Thumb` (300px) -> `Mobile` (1080px) -> `Raw` (Original).
- **UX**: The Hero transition uses the cached thumbnail instantly, while the detail screen asynchronously fades in the higher-resolution mobile version. Raw files are only fetched upon explicit user request via the "Download" button.


