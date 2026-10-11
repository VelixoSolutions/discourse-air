import Component from "@glimmer/component";
import { concat } from "@ember/helper";
import { service } from "@ember/service";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse/helpers/d-icon";
import getURL from "discourse/lib/get-url";

const EXTERNAL_URL = /^https?:\/\//;

export default class VelixoNav extends Component {
  @service currentUser;
  @service router;

  isVisible(link) {
    switch (link.audience) {
      case "staff":
        return !!this.currentUser?.staff;
      case "logged_in":
        return !!this.currentUser;
      case "anonymous":
        return !this.currentUser;
      default:
        return true;
    }
  }

  isActive(url, currentPath) {
    if (url === "/latest" && currentPath === "/") {
      return true;
    }
    return currentPath === url || currentPath.startsWith(`${url}/`);
  }

  get links() {
    const currentPath = (this.router.currentURL || "/").split("?")[0];

    return (settings.nav_links || [])
      .filter((link) => this.isVisible(link))
      .map((link) => {
        const external = EXTERNAL_URL.test(link.url);
        return {
          ...link,
          external,
          href: external ? link.url : getURL(link.url),
          active: !external && this.isActive(link.url, currentPath),
        };
      });
  }

  <template>
    <nav
      class={{concatClass "velixo-nav" (concat "velixo-nav--" @placement)}}
      aria-label="Main"
    >
      <ul class="velixo-nav__list">
        {{#each this.links as |link|}}
          <li class="velixo-nav__item">
            <a
              href={{link.href}}
              class={{concatClass
                "velixo-nav__link"
                (if link.active "--active")
              }}
              aria-current={{if link.active "page"}}
              target={{if link.external "_blank"}}
              rel={{if link.external "noopener noreferrer"}}
            >
              {{#if link.icon}}
                {{icon link.icon}}
              {{/if}}
              <span>{{link.label}}</span>
            </a>
          </li>
        {{/each}}
      </ul>
    </nav>
  </template>
}
