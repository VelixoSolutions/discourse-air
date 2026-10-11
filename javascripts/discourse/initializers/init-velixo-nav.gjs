import { apiInitializer } from "discourse/lib/api";
import VelixoFooter from "../components/velixo-footer";
import VelixoHeroLinks from "../components/velixo-hero-links";
import VelixoHeroSubtitle from "../components/velixo-hero-subtitle";
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

  api.renderInOutlet("welcome-banner-below-headline", VelixoHeroSubtitle);
  api.renderInOutlet("welcome-banner-below-input", VelixoHeroLinks);

  if (settings.show_footer) {
    api.renderInOutlet("below-footer", VelixoFooter);
  }

  // Staff keep the hamburger + sidebar: it is how the admin area is navigated
  if (settings.sidebar_for_staff && api.getCurrentUser()?.staff) {
    document.documentElement.classList.add("velixo-staff-sidebar");
  }
});
