import Component from "@glimmer/component";
import { decorateLink } from "../lib/velixo-links";

export default class VelixoFooter extends Component {
  get legalLinks() {
    return (settings.footer_legal_links || []).map(decorateLink);
  }

  get year() {
    return new Date().getFullYear();
  }

  <template>
    <footer class="velixo-footer">
      <span>©{{this.year}} {{settings.footer_copyright}}</span>
      <ul>
        {{#each this.legalLinks as |link|}}
          <li>
            <a
              href={{link.href}}
              target={{if link.external "_blank"}}
              rel={{if link.external "noopener noreferrer"}}
            >{{link.label}}</a>
          </li>
        {{/each}}
      </ul>
    </footer>
  </template>
}
