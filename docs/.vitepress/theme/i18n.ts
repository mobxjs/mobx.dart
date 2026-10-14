import {computed} from 'vue';
import {useData} from 'vitepress';
import {localizeLink,type ThemeConfig} from '../i18n';

const en={
 hero:{title:['Big ideas.','Simple state.'],body:'Make Dart and Flutter apps that stay in sync. MobX connects your data to the places that need it, automatically. So you can get on with the good stuff.',start:'Start building',example:'Try an example',footnote:'Open source. MIT licensed. Made for Dart.'},
 packages:{label:'MobX packages',title:['Small pieces.','One reactive system.'],mobx:'The reactive core',flutter:'Reactive Flutter widgets',codegen:'Less boilerplate'},
 pieces:{title:['Small pieces.','Wonderful possibilities.'],body:['Learn a few ideas. Use them everywhere.','From your first counter to state shared across an entire app.'],items:{
  observable:['Observable','The state you care about.','A name, a cart, a collection. Make it observable and MobX can track who uses it.'],
  action:['Action','A clear place to make changes.','Update one value or several together. Reactions see the state after the action finishes.'],
  computed:['Computed','Answers that work themselves out.','Totals, filtered lists, validation. Describe how to derive a value, and let MobX keep it current.'],
  reaction:['Reaction','The right response to a change.','Save a draft or respond to a status update. Run an effect when the state it reads changes.'],
  observer:['Observer','Your Flutter UI, connected.','Read observables inside an Observer builder. It rebuilds when those dependencies change.'],
  async:['Futures & streams','Async joins the conversation.','Observe request status and live events, using the same reactive ideas as the rest of your app.'],
 }},
 learning:{title:['From your first counter','to your next big app.'],start:'Get up and running',cheatSheet:'Keep the cheat sheet close',examples:'Learn through examples',book:'Read the MobX Quick Start Guide'},
 close:{title:['Make room for','what you’re building.'],body:'Let MobX take care of keeping state in sync.',button:'Get started with MobX'},
 community:{title:['Built in the open.','Used in the real world.'],body:['Part of the Dart and Flutter community.','Here’s what developers have shared.'],sponsors:'Supported by our sponsors',support:'Support MobX',past:'With thanks to our past sponsors:'},
 companies:{title:'Used by thousands of companies across the world',pause:'Pause logo scrolling',resume:'Resume logo scrolling'},
 examples:{title:['Less keeping track.','More making things.'],body:['Small, readable pieces of Dart.','Connections that keep working as your app grows.'],choose:'Choose a MobX example',live:'Live example',tryIt:'Give it a try',explore:'Explore'},
 triad:{label:'The MobX triad: actions change observable state, reactions respond. User interaction can start another action.',wires:['changes','updates','user interaction'],trigger:'Trigger an action in the MobX triangle',center:'connects the dots',bag:'Bag',caption:'A little change. Everything connected.',pauseLabel:'Pause triangle animation',playLabel:'Play triangle animation',pause:'Pause',play:'Play'},
 flutter:{prompt:'Try the real Flutter example.',run:'Run example',note:'The Flutter runtime loads when you press Run.',loading:'Loading Flutter…',error:'The example could not load. Check your connection and try again.',retry:'Retry',resetLabel:'Reset example',reset:'Reset',open:'Open app'},
};

export const messages={root:en};
export type Locale=keyof typeof messages;

export function useI18n(){
 const {localeIndex,theme}=useData<ThemeConfig>();
 const locale=computed(()=>(localeIndex.value in messages?localeIndex.value:'root') as Locale);
 return {locale,t:computed(()=>messages[locale.value]),link:(url:string)=>localizeLink(url,locale.value,theme.value.translated)};
}
