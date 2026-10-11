import Component from "@glimmer/component";
import { service } from "@ember/service";
import icon from "discourse/helpers/d-icon";
import { decorateLink, isVisibleTo } from "../lib/velixo-links";

export default class VelixoHeroLinks extends Component {
  @service currentUser;

  get links() {
    return (settings.hero_links || [])
      .filter((link) => isVisibleTo(link, this.currentUser))
      .map(decorateLink);
  }

  <template>
    {{#if this.links.length}}
      <ul class="velixo-hero__links">
        {{#each this.links as |link|}}
          <li>
            <a
              href={{link.href}}
              class="velixo-hero__link"
              target={{if link.external "_blank"}}
              rel={{if link.external "noopener noreferrer"}}
            >
              {{#if link.icon}}
                {{icon link.icon}}
              {{/if}}
              <span>{{link.label}}</span>
              {{#if link.external}}
                {{icon "arrow-up-right-from-square" class="velixo-hero__ext"}}
              {{/if}}
            </a>
          </li>
        {{/each}}
      </ul>
    {{/if}}
  </template>
}
