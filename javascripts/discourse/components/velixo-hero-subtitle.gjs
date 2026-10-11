const VelixoHeroSubtitle = <template>
  {{#if settings.hero_subtitle}}
    <p class="velixo-hero__subtitle">{{settings.hero_subtitle}}</p>
  {{/if}}
</template>;

export default VelixoHeroSubtitle;
