import {defineComponent,ref} from 'vue';
import {Arrow} from '../Arrow';
import {CodeSnippet} from '../CodeSnippet';
import FlutterExample from '../FlutterExample.vue';
import examples from '../../data/generated-snippets.json';
export const ExampleShowcase=defineComponent({setup(){
 const selected=ref(0);
 return ()=>{const example=examples[selected.value];
 return <section id="examples" class="example-section home-section" aria-labelledby="examples-title">
   <div class="section-heading"><h2 id="examples-title">Less keeping track.<br/><em>More making things.</em></h2><p>Small, readable pieces of Dart.<br/>Connections that keep working as your app grows.</p></div>
   <div class="example-choices" aria-label="Choose a MobX example">{examples.map((e,i)=><button key={e.id} aria-pressed={selected.value===i} onClick={()=>selected.value=i}>{e.label}</button>)}</div>
   <div class="example-intro"><h3>{example.title}</h3><p>{example.description}</p></div>
   <div class="example-workbench">
     <div class="example-source"><div class="source-heading"><span>{example.file}</span><span>Dart + Flutter</span></div><CodeSnippet html={example.html}/><div class="source-footer"><code>{example.concept}</code><a href={example.link}>Explore <Arrow/></a></div></div>
     <div class="example-result"><div class="result-heading"><span><i/> Live example</span><span>Give it a try</span></div>
       <FlutterExample route={"/"+example.id} height={480}/>
     </div>
   </div>
 </section>;
}; }});
