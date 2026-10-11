import { schedule } from "@ember/runloop";
import { apiInitializer } from "discourse/lib/api";

// #topic-title is sticky (velixo.scss). Publish its height so the sticky post
// avatars and timeline sit below it, and flag when it is pinned so it can
// show a separator.
export default apiInitializer((api) => {
  const root = document.documentElement;
  let resizeObserver;
  let stuckObserver;

  function watch() {
    resizeObserver?.disconnect();
    stuckObserver?.disconnect();
    root.style.removeProperty("--velixo-topic-title-height");
    root.classList.remove("velixo-topic-title-stuck");
    document
      .querySelectorAll(".velixo-topic-title-sentinel")
      .forEach((el) => el.remove());

    const title = document.getElementById("topic-title");
    if (!title) {
      return;
    }

    resizeObserver = new ResizeObserver(([entry]) => {
      root.style.setProperty(
        "--velixo-topic-title-height",
        `${Math.round(entry.borderBoxSize[0].blockSize)}px`
      );
    });
    resizeObserver.observe(title);

    // a 1px sentinel just above the title leaves the viewport when it pins
    const sentinel = document.createElement("div");
    sentinel.className = "velixo-topic-title-sentinel";
    title.before(sentinel);
    const headerOffset =
      parseInt(
        getComputedStyle(root).getPropertyValue("--header-offset"),
        10
      ) || 0;
    stuckObserver = new IntersectionObserver(
      ([entry]) =>
        root.classList.toggle(
          "velixo-topic-title-stuck",
          !entry.isIntersecting
        ),
      { rootMargin: `-${headerOffset + 1}px 0px 0px 0px` }
    );
    stuckObserver.observe(sentinel);
  }

  api.onPageChange(() => schedule("afterRender", watch));
});
