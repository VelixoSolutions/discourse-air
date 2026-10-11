import { schedule } from "@ember/runloop";
import { apiInitializer } from "discourse/lib/api";

// Keeps the white content card (#main-outlet) looking the same scrolled or
// not (styles in velixo.scss):
// - publishes the card's horizontal position so .velixo-card-cap (a navy
//   strip with rounded cutouts, from common/header.html) can sit right under
//   the header, and shows it once the card has scrolled up to it
// - publishes the pinned #topic-title's height so the sticky post avatars and
//   timeline sit below it
export default apiInitializer((api) => {
  const root = document.documentElement;
  let resizeObserver;
  let frame;

  function cardCapTop() {
    const style = getComputedStyle(root);
    return (
      (parseFloat(style.getPropertyValue("--header-offset")) || 0) +
      (parseFloat(style.getPropertyValue("--velixo-card-gap")) || 0)
    );
  }

  function update() {
    frame = null;
    const card = document.getElementById("main-outlet");
    if (!card) {
      return;
    }
    const rect = card.getBoundingClientRect();
    root.style.setProperty("--velixo-card-left", `${rect.left}px`);
    root.style.setProperty("--velixo-card-width", `${rect.width}px`);
    root.classList.toggle("velixo-card-capped", rect.top < cardCapTop() - 0.5);

    const title = document.getElementById("topic-title");
    if (title) {
      root.style.setProperty(
        "--velixo-topic-title-height",
        `${Math.round(title.getBoundingClientRect().height)}px`
      );
    } else {
      root.style.removeProperty("--velixo-topic-title-height");
    }
  }

  function requestUpdate() {
    frame ??= requestAnimationFrame(update);
  }

  window.addEventListener("scroll", requestUpdate, { passive: true });
  window.addEventListener("resize", requestUpdate);

  api.onPageChange(() =>
    schedule("afterRender", () => {
      resizeObserver?.disconnect();
      resizeObserver = new ResizeObserver(requestUpdate);
      for (const id of ["main-outlet", "topic-title"]) {
        const el = document.getElementById(id);
        if (el) {
          resizeObserver.observe(el);
        }
      }
      update();
    })
  );
});
