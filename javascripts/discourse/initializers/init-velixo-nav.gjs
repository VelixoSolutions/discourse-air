import { apiInitializer } from "discourse/lib/api";
import VelixoNav from "../components/velixo-nav";

export default apiInitializer((api) => {
  // Desktop: inline in the header, next to the logo
  api.renderInOutlet(
    "before-header-panel",
    <template><VelixoNav @placement="header" /></template>
  );

  // Small screens: a scrollable strip under the header
  api.renderInOutlet(
    "below-site-header",
    <template><VelixoNav @placement="strip" /></template>
  );

  if (settings.hide_sidebar) {
    document.documentElement.classList.add("velixo-hide-sidebar");
  }
});
