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

const ko:typeof en={
 hero:{title:['아이디어는 크게.','상태는 단순하게.'],body:'언제나 동기화된 Dart와 Flutter 앱을 만드세요. MobX가 데이터를 필요한 곳에 자동으로 연결하니, 정말 중요한 일에 집중할 수 있습니다.',start:'시작하기',example:'예제 실행해 보기',footnote:'오픈 소스. MIT 라이선스. Dart를 위해 만들었습니다.'},
 packages:{label:'MobX 패키지',title:['작은 조각들.','하나의 반응형 시스템.'],mobx:'반응형 코어',flutter:'반응형 Flutter 위젯',codegen:'보일러플레이트 줄이기'},
 pieces:{title:['작은 조각들.','무궁무진한 가능성.'],body:['몇 가지 개념만 익히면 어디서나 쓸 수 있습니다.','첫 카운터부터 앱 전체가 공유하는 상태까지.'],items:{
  observable:['Observable','관심 있는 상태.','이름, 장바구니, 컬렉션. observable로 만들면 MobX가 누가 그 값을 쓰는지 추적합니다.'],
  action:['Action','변경을 위한 분명한 자리.','값 하나든 여러 값이든 함께 바꾸세요. Reaction은 action이 끝난 뒤의 상태를 봅니다.'],
  computed:['Computed','알아서 계산되는 답.','합계, 필터링된 목록, 유효성 검사. 값을 파생하는 방법만 적으면 MobX가 항상 최신으로 유지합니다.'],
  reaction:['Reaction','변화에 맞는 반응.','초안을 저장하거나 상태 변경에 응답하세요. effect는 자신이 읽은 상태가 바뀔 때 실행됩니다.'],
  observer:['Observer','Flutter UI와 바로 연결.','Observer 빌더 안에서 observable을 읽으세요. 그 의존성이 바뀌면 다시 빌드됩니다.'],
  async:['Future와 Stream','비동기도 같은 방식으로.','요청 상태와 실시간 이벤트를 앱의 다른 부분과 같은 반응형 개념으로 관찰합니다.'],
 }},
 learning:{title:['첫 카운터부터','다음 큰 앱까지.'],start:'바로 시작하기',cheatSheet:'치트 시트 곁에 두기',examples:'예제로 배우기',book:'MobX Quick Start Guide 읽기'},
 close:{title:['만들고 있는 것에','집중하세요.'],body:'상태 동기화는 MobX에 맡기세요.',button:'MobX 시작하기'},
 community:{title:['오픈 소스로 만들고,','실제 서비스에서 씁니다.'],body:['Dart와 Flutter 커뮤니티의 일부입니다.','개발자들이 남긴 이야기를 들어 보세요.'],sponsors:'후원해 주신 분들',support:'MobX 후원하기',past:'지난 후원사에도 감사드립니다:'},
 companies:{title:'전 세계 수많은 기업이 사용하고 있습니다',pause:'로고 스크롤 일시 정지',resume:'로고 스크롤 재개'},
 examples:{title:['추적은 덜 하고,','만드는 일은 더 많이.'],body:['작고 읽기 쉬운 Dart 코드.','앱이 커져도 연결은 계속 동작합니다.'],choose:'MobX 예제 선택',live:'라이브 예제',tryIt:'직접 해 보세요',explore:'자세히 보기'},
 triad:{label:'MobX 삼각형: action이 observable 상태를 바꾸고 reaction이 반응합니다. 사용자 상호작용은 다시 새로운 action을 시작할 수 있습니다.',wires:['변경','갱신','사용자 상호작용'],trigger:'MobX 삼각형에서 action 실행',center:'모든 것을 연결합니다',bag:'장바구니',caption:'작은 변화 하나. 모든 것이 연결됩니다.',pauseLabel:'삼각형 애니메이션 일시 정지',playLabel:'삼각형 애니메이션 재생',pause:'일시 정지',play:'재생'},
 flutter:{prompt:'실제 Flutter 예제를 실행해 보세요.',run:'예제 실행',note:'실행을 누르면 Flutter 런타임을 불러옵니다.',loading:'Flutter 불러오는 중…',error:'예제를 불러오지 못했습니다. 네트워크 연결을 확인한 뒤 다시 시도하세요.',retry:'다시 시도',resetLabel:'예제 초기화',reset:'초기화',open:'앱 열기'},
};

export const messages={root:en,ko};
export type Locale=keyof typeof messages;

export function useI18n(){
 const {localeIndex,theme}=useData<ThemeConfig>();
 const locale=computed(()=>(localeIndex.value in messages?localeIndex.value:'root') as Locale);
 return {locale,t:computed(()=>messages[locale.value]),link:(url:string)=>localizeLink(url,locale.value,theme.value.translated)};
}
