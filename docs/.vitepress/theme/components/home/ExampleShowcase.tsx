import {defineComponent,ref} from 'vue';
import {Arrow} from '../Arrow';
import {CodeSnippet} from '../CodeSnippet';
import FlutterExample from '../FlutterExample.vue';
import examples from '../../data/generated-snippets.json';
import {useI18n} from '../../i18n';
export const ExampleShowcase=defineComponent({setup(){
 const selected=ref(0),{locale,t:messages,link}=useI18n();
 return ()=>{const t=messages.value.examples,localize=(e:typeof examples[number])=>({...e,...(locale.value==='root'?{}:e.translations[locale.value])}),example=localize(examples[selected.value]);
 return <section id="examples" class="example-section home-section" aria-labelledby="examples-title">
   <div class="section-heading"><h2 id="examples-title">{t.title[0]}<br/><em>{t.title[1]}</em></h2><p>{t.body[0]}<br/>{t.body[1]}</p></div>
   <div class="example-choices" aria-label={t.choose}>{examples.map((e,i)=><button key={e.id} aria-pressed={selected.value===i} onClick={()=>selected.value=i}>{localize(e).label}</button>)}</div>
   <div class="example-intro"><h3>{example.title}</h3><p>{example.description}</p></div>
   <div class="example-workbench">
     <div class="example-source"><div class="source-heading"><span>{example.file}</span><span>Dart + Flutter</span></div><CodeSnippet html={example.html}/><div class="source-footer"><code>{example.concept}</code><a href={link(example.link)}>{t.explore} <Arrow/></a></div></div>
     <div class="example-result"><div class="result-heading"><span><i/> {t.live}</span><span>{t.tryIt}</span></div>
       <FlutterExample route={"/"+example.id} height={480}/>
     </div>
   </div>
 </section>;
}; }});
