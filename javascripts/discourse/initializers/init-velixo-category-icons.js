import { schedule } from "@ember/runloop";
import { apiInitializer } from "discourse/lib/api";
import { iconHTML } from "discourse/lib/icon-library";
import Category from "discourse/models/category";

// The category boxes component shows a two-letter abbreviation when a
// category has no logo; show the category's own icon instead.
function replaceAbbreviations() {
  document
    .querySelectorAll(".category-box .category-abbreviation")
    .forEach((abbr) => {
      const box = abbr.closest("[data-category-id]");
      const category = Category.findById(Number(box?.dataset.categoryId));
      if (category?.style_type !== "icon" || !category.icon) {
        return;
      }
      const wrapper = document.createElement("span");
      wrapper.className = "velixo-category-icon";
      wrapper.innerHTML = iconHTML(category.icon);
      abbr.replaceWith(wrapper);
    });
}

export default apiInitializer((api) => {
  if (!settings.category_box_icons) {
    return;
  }

  api.onPageChange(() => schedule("afterRender", replaceAbbreviations));
});
