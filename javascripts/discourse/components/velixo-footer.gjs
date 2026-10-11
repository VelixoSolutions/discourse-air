import Component from "@glimmer/component";
import { decorateLink } from "../lib/velixo-links";

const LOGO_URL = "https://secure.velixo.com/logos/logo-full-gradient-white.svg";

export default class VelixoFooter extends Component {
  get sections() {
    const sections = new Map();
    for (const link of settings.footer_links || []) {
      if (!sections.has(link.section)) {
        sections.set(link.section, []);
      }
      sections.get(link.section).push(decorateLink(link));
    }
    return [...sections].map(([title, links]) => ({ title, links }));
  }

  get year() {
    return new Date().getFullYear();
  }

  <template>
    <footer class="velixo-footer">
      <div class="velixo-footer__inner">
        <div class="velixo-footer__brand">
          <img src={{LOGO_URL}} alt="Velixo" class="velixo-footer__logo" />
          {{#if settings.footer_tagline}}
            <p>{{settings.footer_tagline}}</p>
          {{/if}}
        </div>
        {{#each this.sections as |section|}}
          <nav class="velixo-footer__col" aria-label={{section.title}}>
            <h3>{{section.title}}</h3>
            <ul>
              {{#each section.links as |link|}}
                <li>
                  <a
                    href={{link.href}}
                    target={{if link.external "_blank"}}
                    rel={{if link.external "noopener noreferrer"}}
                  >{{link.label}}</a>
                </li>
              {{/each}}
            </ul>
          </nav>
        {{/each}}
      </div>
      <div class="velixo-footer__legal">© {{this.year}} Velixo</div>
    </footer>
  </template>
}
