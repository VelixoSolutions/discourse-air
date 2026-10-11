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

  // Keep the full logo when scrolling into a topic. Core swaps it for
  // logo_small (unset on this site, so the logo vanished) while the header
  // shows the topic title, which the pinned #topic-title replaces anyway.
  api.registerValueTransformer("home-logo-minimized", () => false);

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
