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

  get legalLinks() {
    return (settings.footer_legal_links || []).map(decorateLink);
  }

  get phoneHref() {
    return `tel:${settings.footer_phone.replace(/[^\d+]/g, "")}`;
  }

  get year() {
    return new Date().getFullYear();
  }

  <template>
    <footer class="velixo-footer">
      <div class="velixo-footer__inner">
        <div class="velixo-footer__brand">
          <img src={{LOGO_URL}} alt="Velixo" class="velixo-footer__logo" />
          <ul class="velixo-footer__contact">
            {{#if settings.footer_email}}
              <li><a
                  href="mailto:{{settings.footer_email}}"
                >{{settings.footer_email}}</a></li>
            {{/if}}
            {{#if settings.footer_phone}}
              <li><a href={{this.phoneHref}}>{{settings.footer_phone}}</a></li>
            {{/if}}
          </ul>
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
      <div class="velixo-footer__legal">
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
      </div>
    </footer>
  </template>
}
