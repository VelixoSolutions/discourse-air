import { apiInitializer } from "discourse/lib/api";

// Tag URLs are lowercase (/tag/acumatica/1). Right after switching tabs, the
// tag filter labels itself from the URL until the topic list arrives, so a
// tag named "Acumatica" flashes as "acumatica". Label it with the tag's real
// name instead: from the site's tag list, or as last seen on this visit.
export default apiInitializer((api) => {
  const site = api.container.lookup("service:site");
  const seen = new Map(); // lowercase name → name as written

  const properName = (tag, value) => {
    const name = tag?.name;
    if (!name) {
      return name;
    }

    const key = name.toLowerCase();
    if (name !== key) {
      seen.set(key, name);
      return name;
    }

    const known = (site.top_tags || []).find(
      (t) =>
        typeof t === "object" &&
        (String(t.id) === String(value) ||
          t.slug === key ||
          t.name?.toLowerCase() === key)
    );

    return known?.name || seen.get(key) || name;
  };

  api.modifyClass(
    "component:tag-drop",
    (Superclass) =>
      class extends Superclass {
        modifySelection(content) {
          const selection = super.modifySelection(content);
          const name = properName(this.tag, this.value);

          // only re-case the tag's own name (not "All tags", "No tags", …)
          if (
            name &&
            selection?.name !== name &&
            selection?.name?.toLowerCase() === name.toLowerCase()
          ) {
            return this.defaultItem(this.value, name);
          }

          return selection;
        }
      }
  );
});
