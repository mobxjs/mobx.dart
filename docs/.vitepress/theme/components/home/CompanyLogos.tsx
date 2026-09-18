import { defineComponent, ref } from 'vue';
import { Pause, Play } from '@lucide/vue';

// Approved company names and locally stored logos.
const companies = [
  { name: 'YONO SBI', file: 'yono.png', url: 'https://sbi.bank.in/web/yono' },
  { name: 'Tata Neu', file: 'tata.svg', url: 'https://www.tataneu.com/' },
  { name: 'Nubank', file: 'nubank.svg', url: 'https://nubank.com.br/', label: 'Nubank' },
  { name: 'GoHighLevel', file: 'highlevel.svg', url: 'https://www.gohighlevel.com/' },
  { name: 'Vyuh Technologies', file: 'vyuh.svg', url: 'https://vyuh.tech/', label: 'Vyuh' },
  { name: 'Multipl', file: 'multipl.png', url: 'https://multipl.in/', label: 'Multipl' },
  { name: "It's All Widgets!", file: 'its-all-widgets.png', url: 'https://itsallwidgets.com/podcast' },
  { name: 'Supernova', file: 'supernova.svg', url: 'https://www.supernova.io/' },
  { name: 'Hyper Zones', file: 'hyperzones.png', url: 'https://hyperzones.app/', label: 'Hyper Zones' },
];

export const CompanyLogos = defineComponent({
  setup() {
    const paused = ref(false);
    return () => (
      <section class="company-section home-section" aria-labelledby="companies-title">
        <div class="company-heading">
          <h2 id="companies-title">Built with MobX.</h2>
          <button class="company-motion" type="button" aria-label={paused.value ? 'Resume logo scrolling' : 'Pause logo scrolling'} aria-pressed={paused.value} onClick={() => paused.value = !paused.value}>
            {paused.value ? <Play size={16} /> : <Pause size={16} />}
          </button>
        </div>
        <div class={['company-window', { 'is-paused': paused.value }]}>
          <div class="company-track">
            {[false, true].map(duplicate => <ul class="company-list" aria-hidden={duplicate ? 'true' : undefined} key={String(duplicate)}>
              {companies.map(company => <li key={company.name}>
                <a href={company.url} aria-label={company.name} tabindex={duplicate ? -1 : undefined}>
                  {company.file && <img src={'/images/companies/' + company.file} alt={company.label ? '' : company.name} width="160" height="48" loading="lazy" class={company.label ? 'company-symbol' : ''} />}
                  {company.label && <span>{company.label}</span>}
                </a>
              </li>)}
            </ul>)}
          </div>
        </div>
      </section>
    );
  },
});
