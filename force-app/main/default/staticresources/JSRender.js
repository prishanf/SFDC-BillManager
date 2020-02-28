﻿/*! JsRender v1.0.0-beta: http://github.com/BorisMoore/jsrender and http://jsviews.com/jsviews
informal pre V1.0 commit counter: 51 */
(function(n,t,i){"use strict";function pt(n){return n}function pi(n){return n}function wt(n){e._dbgMode=n;lt=n?"Error: #index in nested view: use #getIndex()":"";nt("dbg",ui.dbg=ht.dbg=n?pi:pt)}function bt(n){return{getTgt:n,map:function(t){var i=this,r;i.src!==t&&(i.src&&i.unmap(),typeof t=="object"&&(r=n.apply(i,arguments),i.src=t,i.tgt=r))}}}function ut(n,t){t&&t.onError&&t.onError(n)===!1||(this.name="JsRender Error",this.message=n||"JsRender error")}function u(n,t){var i;n=n||{};for(i in t)n[i]=t[i];return n}function kt(n,t,i){return(!v.rTag||n)&&(p=n?n.charAt(0):p,w=n?n.charAt(1):w,o=t?t.charAt(0):o,l=t?t.charAt(1):l,k=i||k,n="\\"+p+"(\\"+k+")?\\"+w,t="\\"+o+"\\"+l,y="(?:(?:(\\w+(?=[\\/\\s\\"+o+"]))|(?:(\\w+)?(:)|(>)|!--((?:[^-]|-(?!-))*)--|(\\*)))\\s*((?:[^\\"+o+"]|\\"+o+"(?!\\"+l+"))*?)",v.rTag=y+")",y=new RegExp(n+y+"(\\/)?|(?:\\/(\\w+)))"+t,"g"),ct=new RegExp("<.*>|([^\\\\]|^)[{}]|"+n+".*"+t)),[p,w,o,l,k]}function wi(n,t){t||(t=n,n=i);var e,f,o,u,r=this,s=!t||t==="root";if(n){if(u=r.type===t?r:i,!u)if(e=r.views,r._.useKey){for(f in e)if(u=e[f].get(n,t))break}else for(f=0,o=e.length;!u&&f<o;f++)u=e[f].get(n,t)}else if(s)while(r.parent.parent)u=r=r.parent;else while(r&&!u)u=r.type===t?r:i,r=r.parent;return u}function dt(){var n=this.get("item");return n?n.index:i}function gt(){return this.index}function bi(t){var f,e=this,o=e.linkCtx,r=(e.ctx||{})[t];return r===i&&o&&o.ctx&&(r=o.ctx[t]),r===i&&(r=ui[t]),r&&(typeof r!="function"||r._wrp||(f=function(){return r.apply(!this||this===n?e:this,arguments)},f._wrp=1,u(f,r))),f||r}function ki(n,t,u){var h,f,e,o=+u===u&&u,s=t.linkCtx;return o&&(u=(o=t.tmpl.bnds[o-1])(t.data,t,r)),e=u.args[0],(n||o)&&(f=s&&s.tag||{_:{inline:!s,bnd:o},tagName:n+":",flow:!0,_is:"tag"},s&&(s.tag=f,f.linkCtx=f.linkCtx||s,u.ctx=c(u.ctx,s.view.ctx)),f.tagCtx=u,u.view=t,f.ctx=u.ctx||{},delete u.ctx,t._.tag=f,n=n!=="true"&&n,n&&((h=t.getRsc("converters",n))||a("Unknown converter: {{"+n+":"))&&(f.depends=h.depends,e=h.apply(f,u.args)),e=e!=i?e:"",e=o&&t._.onRender?t._.onRender(e,t,o):e,t._.tag=i),e}function di(n,t){for(var f,e,u=this;f===i&&u;)e=u.tmpl[n],f=e&&e[t],u=u.parent;return f||r[n][t]}function gi(n,t,f,e,o){var et,h,at,ot,it,v,st,w,l,rt,nt,vt,b,ct,lt,g,y,k="",ut=+e===e&&e,p=t.linkCtx||0,tt=t.ctx,yt=f||t.tmpl,pt=t._;for(n._is==="tag"&&(h=n,n=h.tagName),ut&&(e=(vt=yt.bnds[ut-1])(t.data,t,r)),st=e.length,h=h||p.tag,v=0;v<st;v++)l=e[v],nt=l.tmpl,nt=l.content=nt&&yt.tmpls[nt-1],f=l.props.tmpl,v||f&&h||(b=t.getRsc("tags",n)||a("Unknown tag: {{"+n+"}}")),f=f||(h?h:b).template||nt,f=""+f===f?t.getRsc("templates",f)||s(f):f,u(l,{tmpl:f,render:ft,index:v,view:t,ctx:c(l.ctx,tt)}),h||(b._ctr?(h=new b._ctr,ct=!!h.init,h.attr=h.attr||b.attr||i):h={render:b.render},h._={inline:!p},p&&(p.attr=h.attr=p.attr||h.attr,p.tag=h,h.linkCtx=p),(h._.bnd=vt||p.fn)?h._.arrVws={}:h.dataBoundOnly&&a("{^{"+n+"}} tag must be data-bound"),h.tagName=n,h.parent=it=tt&&tt.tag,h._is="tag",h._def=b),l.tag=h,h.map&&h.tagCtxs&&(l.map=h.tagCtxs[v].map),h.flow||(rt=l.ctx=l.ctx||{},at=h.parents=rt.parentTags=tt&&c(rt.parentTags,tt.parentTags)||{},it&&(at[it.tagName]=it),rt.tag=h);for(h.tagCtxs=e,pt.tag=h,h.rendering={},v=0;v<st;v++)l=h.tagCtx=e[v],y=l.args,(lt=l.props.map||h).map&&(y.length||!v||l.props.map)&&(y.length||(y=[t.data]),g=l.map=u(l.map||{unmap:lt.unmap},l.props),g.src!==y[0]&&(g.src&&g.unmap(),lt.map.apply(g,y)),y=[g.tgt]),h.ctx=l.ctx,!v&&ct&&(h.init(l,p,h.ctx),l=h.tagCtx,ct=i),w=i,et=h.render,(et=h.render)&&(w=et.apply(h,y)),w=w!==i?w:l.tmpl&&l.render(y[0],i,!0)||(o?i:""),k=k?k+(w||""):w;return delete h.rendering,h.tagCtx=h.tagCtxs[0],h.ctx=h.tagCtx.ctx,h._.inline&&(ot=h.attr)&&ot!==d&&(k=ot==="text"?ht.html(k):""),ut&&t._.onRender?t._.onRender(k,t,ut):k}function g(n,t,i,r,u,f,e,o){var a,h,c,v=t==="array",l={key:0,useKey:v?0:1,id:""+yi++,onRender:o,bnds:{}},s={data:r,tmpl:u,content:e,views:v?[]:{},parent:i,type:t,get:wi,getIndex:gt,getRsc:di,hlp:bi,_:l,_is:"view"};return i?(a=i.views,h=i._,h.useKey?(a[l.key="_"+h.useKey++]=s,s.index=lt,s.getIndex=dt,c=h.tag,l.bnd=v&&(!c||!!c._.bnd&&c)):a.splice(l.key=s.index=f,0,s),s.ctx=n||i.ctx):s.ctx=n,s}function nr(n){var t,i,r,u,f;for(t in b)if(u=b[t],(f=u.compile)&&(i=n[t+"s"]))for(r in i)i[r]=f(r,i[r],n,t,u)}function tr(n,t,i){var u,r;return typeof t=="function"?t={depends:t.depends,render:t}:((r=t.template)&&(t.template=""+r===r?s[r]||s(r):r),t.init!==!1&&(u=t._ctr=function(){},(u.prototype=t).constructor=u)),i&&(t._parentTmpl=i),t}function ni(r,u,f,e,o,h){function v(i){if(""+i===i||i.nodeType>0){try{a=i.nodeType>0?i:!ct.test(i)&&t&&t(n.document).find(i)[0]}catch(u){}return a&&(i=a.getAttribute(yt),r=r||i,i=s[i],i||(r=r||"_"+vi++,a.setAttribute(yt,r),i=s[r]=ni(r,a.innerHTML,f,e,o,h))),i}}var l,a;return u=u||"",l=v(u),h=h||(u.markup?u:{}),h.tmplName=r,f&&(h._parentTmpl=f),!l&&u.markup&&(l=v(u.markup))&&l.fn&&(l.debug!==u.debug||l.allowCode!==u.allowCode)&&(l=l.markup),l!==i?(r&&!f&&(rt[r]=function(){return u.render.apply(u,arguments)}),l.fn||u.fn?l.fn&&(u=r&&r!==l.tmplName?c(h,l):l):(u=ti(l,h),et(l.replace(si,"\\$&"),u)),nr(h),u):void 0}function ti(n,t){var i,o=e.wrapMap||{},r=u({markup:n,tmpls:[],links:{},tags:{},bnds:[],_is:"template",render:ft},t);return t.htmlTag||(i=li.exec(n),r.htmlTag=i?i[1].toLowerCase():""),i=o[r.htmlTag],i&&i!==o.div&&(r.markup=f.trim(r.markup)),r}function ir(n,t){function u(e,o,s){var l,h,a,c;if(e&&""+e!==e&&!e.nodeType&&!e.markup){for(a in e)u(a,e[a],o);return r}return o===i&&(o=e,e=i),e&&""+e!==e&&(s=o,o=e,e=i),c=s?s[f]=s[f]||{}:u,h=t.compile,(l=v.onBeforeStoreItem)&&(h=l(c,e,o,h)||h),e?o===null?delete c[e]:c[e]=h?o=h(e,o,s,n,t):o:o=h(i,o),h&&o&&(o._is=n),(l=v.onStoreItem)&&l(c,e,o,h),o}var f=n+"s";r[f]=u;b[n]=t}function ft(n,t,u,e,o,h){var w,ft,tt,y,it,rt,ut,b,p,et,k,ot,l,v=this,st=!v.attr||v.attr===d,nt="";if(o===!0&&(ut=!0,o=0),v.tag?(b=v,v=v.tag,et=v._,ot=v.tagName,l=b.tmpl,t=c(t,v.ctx),p=b.content,b.props.link===!1&&(t=t||{},t.link=!1),e=e||b.view,n=n===i?e:n):l=v.jquery&&(v[0]||a('Unknown template: "'+v.selector+'"'))||v,l&&(!e&&n&&n._is==="view"&&(e=n),e&&(p=p||e.content,h=h||e._.onRender,n===e&&(n=e.data,u=!0),t=c(t,e.ctx)),e&&e.data!==i||((t=t||{}).root=n),l.fn||(l=s[l]||s(l)),l)){if(h=(t&&t.link)!==!1&&st&&h,k=h,h===!0&&(k=i,h=e._.onRender),t=l.helpers?c(l.helpers,t):t,f.isArray(n)&&!u)for(y=ut?e:o!==i&&e||g(t,"array",e,n,l,o,p,h),w=0,ft=n.length;w<ft;w++)tt=n[w],it=g(t,"item",y,tt,l,(o||0)+w,p,h),rt=l.fn(tt,it,r),nt+=y._.onRender?y._.onRender(rt,it):rt;else y=ut?e:g(t,ot||"data",e,n,l,o,p,h),et&&!v.flow&&(y.tag=v),nt+=l.fn(n,y,r);return k?k(nt,y):nt}return""}function a(n){throw new v.Error(n);}function h(n){a("Syntax error\n"+n)}function et(n,t,i,r){function a(t){t-=f;t&&s.push(n.substr(f,t).replace(it,"\\n"))}function c(t){t&&h('Unmatched or missing tag: "{{/'+t+'}}" in template:\n'+n)}function v(e,v,y,w,b,k,g,nt,tt,rt,ut,ft){k&&(b=":",w=d);rt=rt||i;var vt,ht,ct=v&&[],st="",et="",lt="",at=!rt&&!b&&!g;y=y||b;a(ft);f=ft+e.length;nt?p&&s.push(["*","\n"+tt.replace(oi,"$1")+"\n"]):y?(y==="else"&&(ci.test(tt)&&h('for "{{else if expr}}" use "{{else expr}}"'),ct=u[6],u[7]=n.substring(u[7],ft),u=o.pop(),s=u[3],at=!0),tt&&(tt=tt.replace(it," "),st=ot(tt,ct,t).replace(hi,function(n,t,i){return t?lt+=i+",":et+=i+",",""})),et=et.slice(0,-1),st=st.slice(0,-1),vt=et&&et.indexOf("noerror:true")+1&&et||"",l=[y,w||!!r||"",st,at&&[],'params:"'+tt+'",props:{'+et+"}"+(lt?",ctx:{"+lt.slice(0,-1)+"}":""),vt,ct||0],s.push(l),at&&(o.push(u),u=l,u[7]=f)):ut&&(ht=u[0],c(ut!==ht&&ht!=="else"&&ut),u[7]=n.substring(u[7],ft),u=o.pop());c(!u&&ut);s=u[3]}var l,p=t&&t.allowCode,e=[],f=0,o=[],s=e,u=[,,,e];return c(o[0]&&o[0][3].pop()[0]),n.replace(y,v),a(n.length),(f=e[e.length-1])&&c(""+f!==f&&+f[7]===f[7]&&f[0]),ii(e,i?n:t,i)}function ii(n,i,r){var l,f,o,a,v,p,ht,ct,lt,at,et,w,s,ot,y,tt,b,rt,vt,k,yt,pt,st,ut,g,c=0,u="",nt="",ft={},wt=n.length;for(""+i===i?(y=r?'data-link="'+i.replace(it," ").slice(1,-1)+'"':i,i=0):(y=i.tmplName||"unnamed",i.allowCode&&(ft.allowCode=!0),i.debug&&(ft.debug=!0),w=i.bnds,ot=i.tmpls),l=0;l<wt;l++)if(f=n[l],""+f===f)u+='\nret+="'+f+'";';else if(o=f[0],o==="*")u+=""+f[1];else{if(a=f[1],v=f[2],rt=f[3],p=f[4],nt=f[5],vt=f[7],(pt=o==="else")||(c=0,w&&(s=f[6])&&(c=w.push(s))),(st=o===":")?(a&&(o=a===d?">":a+o),nt&&(ut="prm"+l,nt="try{var "+ut+"=["+v+"][0];}catch(e){"+ut+'="";}\n',v=ut)):(rt&&(tt=ti(vt,ft),tt.tmplName=y+"/"+o,ii(rt,tt),ot.push(tt)),pt||(b=o,yt=u,u=""),k=n[l+1],k=k&&k[0]==="else"),p+=",args:["+v+"]}",st&&s||a&&o!==">"){if(g=new Function("data,view,j,u"," // "+y+" "+c+" "+o+"\n"+nt+"return {"+p+";"),g.paths=s,g._ctxs=o,r)return g;et=1}if(u+=st?"\n"+(s?"":nt)+(r?"return ":"ret+=")+(et?(et=0,at=!0,'c("'+a+'",view,'+(s?(w[c-1]=g,c):"{"+p)+");"):o===">"?(ct=!0,"h("+v+");"):(lt=!0,"(v="+v+")!="+(r?"=":"")+'u?v:"";')):(ht=!0,"{view:view,tmpl:"+(rt?ot.length:"0")+","+p+","),b&&!k){if(u="["+u.slice(0,-1)+"]",(r||s)&&(u=new Function("data,view,j,u"," // "+y+" "+c+" "+b+"\nreturn "+u+";"),s&&((w[c-1]=u).paths=s),u._ctxs=o,r))return u;u=yt+'\nret+=t("'+b+'",view,this,'+(c||u)+");";s=0;b=0}}u="// "+y+"\nvar j=j||"+(t?"jQuery.":"js")+"views"+(lt?",v":"")+(ht?",t=j._tag":"")+(at?",c=j._cnvt":"")+(ct?",h=j.converters.html":"")+(r?";\n":',ret="";\n')+(e.tryCatch?"try{\n":"")+(ft.debug?"debugger;":"")+u+(r?"\n":"\nreturn ret;\n")+(e.tryCatch?"\n}catch(e){return j._err(e);}":"");try{u=new Function("data,view,j,u",u)}catch(bt){h("Compiled template code:\n\n"+u,bt)}return i&&(i.fn=u),u}function ot(n,t,i){function b(b,k,d,g,nt,tt,it,rt,ut,ft,st,ht,ct,lt,at,vt,yt,pt,wt,bt){function dt(n,i,r,f,e,o,h,l){if(r&&(t&&(u==="linkTo"&&(s=t._jsvto=t._jsvto||[],s.push(nt)),(!u||c)&&t.push(nt.slice(i.length))),r!==".")){var a=(f?'view.hlp("'+f+'")':e?"view":"data")+(l?(o?"."+o:f?"":e?"":"."+r)+(h||""):(l=f?"":e?o||"":r,""));return a=a+(l?"."+l:""),i+(a.slice(0,9)==="view.data"?a.slice(5):a)}return n}var kt;if(tt=tt||"",d=d||k||ht,nt=nt||ut,ft=ft||yt||"",!it||e||f)return t&&vt&&!e&&!f&&(!u||c||s)&&(kt=v[r],bt.length-1>wt-kt&&(kt=bt.slice(kt,wt+1),vt=w+":"+kt+o,vt=y[vt]=y[vt]||et(p+vt+l,i,!0),vt.paths||ot(kt,vt.paths=[],i),(s||t).push({_jsvOb:vt}))),e?(e=!ct,e?b:'"'):f?(f=!lt,f?b:'"'):(d?(r++,v[r]=wt++,d):"")+(pt?r?"":u?(u=c=s=!1,"\b"):",":rt?(r&&h(n),u=nt,c=g,"\b"+nt+":"):nt?nt.split("^").join(".").replace(fi,dt)+(ft?(a[++r]=!0,nt.charAt(0)!=="."&&(v[r]=wt),ft):tt):tt?tt:at?(a[r--]=!1,at)+(ft?(a[++r]=!0,ft):""):st?(a[r]||h(n),","):k?"":(e=ct,f=lt,'"'));h(n)}var u,s,c,y=i.links,a={},v={0:-1},r=0,f=!1,e=!1;return(n+" ").replace(/\)\^/g,").").replace(ei,b)}function c(n,t){return n&&n!==t?t?u(u({},t),n):n:t&&u({},t)}function ri(n){return vt[n]||(vt[n]="&#"+n.charCodeAt(0)+";")}function rr(n){var i,t,r=[];if(typeof n=="object")for(i in n)t=n[i],t&&t.toJSON&&!t.toJSON()||typeof t!="function"&&r.push({key:i,prop:n[i]});return r}if((!t||!t.views)&&!n.jsviews){var f,tt,y,ct,lt,p="{",w="{",o="}",l="}",k="^",fi=/^(!*?)(?:null|true|false|\d[\d.]*|([\w$]+|\.|~([\w$]+)|#(view|([\w$]+))?)([\w$.^]*?)(?:[.[^]([\w$]+)\]?)?)$/g,ei=/(\()(?=\s*\()|(?:([([])\s*)?(?:(\^?)(!*?[#~]?[\w$.^]+)?\s*((\+\+|--)|\+|-|&&|\|\||===|!==|==|!=|<=|>=|[<>%*:?\/]|(=))\s*|(!*?[#~]?[\w$.^]+)([([])?)|(,\s*)|(\(?)\\?(?:(')|("))|(?:\s*(([)\]])(?=\s*\.|\s*\^|\s*$)|[)\]])([([]?))|(\s+)/g,it=/[ \t]*(\r\n|\n|\r)/g,oi=/\\(['"])/g,si=/['"\\]/g,hi=/\x08(~)?([^\x08]+)\x08/g,ci=/^if\s/,li=/<(\w+)[>\s]/,at=/[\x00`><"'&]/g,ai=at,vi=0,yi=0,vt={"&":"&amp;","<":"&lt;",">":"&gt;","\x00":"&#0;","'":"&#39;",'"':"&#34;","`":"&#96;"},d="html",yt="data-jsv-tmpl",rt={},b={template:{compile:ni},tag:{compile:tr},helper:{},converter:{}},r={jsviews:"v1.0.0-beta",render:rt,settings:function(n){u(e,n);wt(e._dbgMode);e.jsv&&e.jsv()},sub:{View:g,Error:ut,tmplFn:et,parse:ot,extend:u,error:a,syntaxError:h,DataMap:bt},_cnvt:ki,_tag:gi,_err:function(n){return e._dbgMode?"Error: "+(n.message||n)+". ":""}};(ut.prototype=new Error).constructor=ut;dt.depends=function(){return[this.get("item"),"index"]};gt.depends=function(){return["index"]};for(tt in b)ir(tt,b[tt]);var st,s=r.templates,ht=r.converters,ui=r.helpers,nt=r.tags,v=r.sub,e=r.settings;t?(f=t,f.fn.render=ft,(st=f.observable)&&(u(v,st.sub),delete st.sub)):(f=n.jsviews={},f.isArray=Array&&Array.isArray||function(n){return Object.prototype.toString.call(n)==="[object Array]"});f.render=rt;f.views=r;f.templates=s=r.templates;e({debugMode:wt,delimiters:kt,_dbgMode:!0,tryCatch:!0});nt({"else":function(){},"if":{render:function(n){var t=this;return t.rendering.done||!n&&(arguments.length||!t.tagCtx.index)?"":(t.rendering.done=!0,t.selected=t.tagCtx.index,t.tagCtx.render())},onUpdate:function(n,t,i){for(var r,f,u=0;(r=this.tagCtxs[u])&&r.args.length;u++)if(r=r.args[0],f=!r!=!i[u].args[0],!!r||f)return f;return!1},flow:!0},"for":{render:function(n){var t=this,r=t.tagCtx,u="",e=0;return arguments.length||(n=r.view.data),t.rendering.done||(n!==i&&(u+=r.render(n),e+=f.isArray(n)?n.length:1),(t.rendering.done=e)&&(t.selected=r.index)),u},flow:!0},include:{flow:!0},"*":{render:pt,flow:!0}});nt({props:u(u({},nt["for"]),bt(rr))});ht({html:function(n){return n!=i?String(n).replace(ai,ri):""},attr:function(n){return n!=i?String(n).replace(at,ri):n===null?n:""},url:function(n){return n!=i?encodeURI(String(n)):n===null?n:""}});kt()}})(this,this.jQuery);
/*
//# sourceMappingURL=jsrender.min.js.map
*/