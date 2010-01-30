package sg.gaialegs.pages
{
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	import flash.text.StyleSheet;
	
	import com.flashartofwar.fcss.stylesheets.FStyleSheet;
	import com.gaiaframework.templates.AbstractPage;
	import com.gaiaframework.events.*;
	import com.gaiaframework.debug.*;
	import com.gaiaframework.api.*;
	import flash.display.*;
	import flash.events.*;
	import org.robotlegs.core.*;
	import sg.camo.interfaces.IBehaviouralBase;
	import sg.camogxmlgaia.api.ISourceAsset;
	import sg.fcss.interfaces.IStyleRequester;
	import sg.fcss.utils.StylesheetRequester;
	import sg.gaialegs.framework.IMainContextProvider;
	
	import sg.camogxml.managers.BehaviourManager;
	import sg.camogxml.managers.DisplayRenderManager;
	import sg.camogxmlgaia.pages.GXMLIndexTree;
	
	import sg.camogxmlgaia.inject.NodeClassSpawnerManager;
	import sg.camogxml.seo.SEOPageRenderer;
	import sg.camogxml.managers.gs.GSTransitionManager;
	
	import sg.camogxml.managers.GPropertySheetManager;
	import sg.camogxml.managers.DefinitionsManager;
	import sg.camogxml.render.*;
	import camo.core.property.PropertySheet;
	import sg.camogxml.render.GXMLBehaviours;
	import sg.camogxml.dummy.EmptyDefinitionGetter;
	
	
	

	
	public class IndexPage extends GXMLIndexTree
	{	
		public function IndexPage()
		{
			super();
			alpha = 0;
			
			NodeClassSpawnerManager
			SEOPageRenderer;
			GSTransitionManager;
			
			// -- Stacks
			//BehaviourManager;
			DisplayRenderManager;
			//GPropertySheetManager
			DefinitionsManager
			
			// -- DummySources
			//EmptyDefinitionGetter
			
			// -- Renders
			//	GXMLPageRender;
			//GXMLPersistantRender;
			//GXMLModuleRender;
			//GXMLRender
			
			// -- Raw
			//PropertySheet
			GXMLBehaviours
			GXMLDefinitions
		}
		
	
		override public function transitionIn():void 
		{
			super.transitionIn();
			
			// Do some manual wiring here remotely on core behaviours/stylesheets
			var mainContextProvider:IMainContextProvider = (assets.maincore as IDisplayObject).loader.content as IMainContextProvider;
			mainContextProvider.startup(stage);
			
			var injector:IInjector = mainContextProvider.getInjector();
	
			injector.mapValue( IBehaviouralBase, (assets.behaviours as ISourceAsset).source );
			var coreStylesheet:FStyleSheet = new FStyleSheet();
			var styleRequester:StylesheetRequester = new StylesheetRequester(coreStylesheet);
			coreStylesheet.parseCSS( (assets.props as IText).text );
			injector.mapValue( IStyleSheet, coreStylesheet);
			injector.mapValue( IStyleRequester, styleRequester ); // 
			injector.mapValue( StyleSheet, (assets.stylesheet as com.gaiaframework.api.IStyleSheet).style, "textStyle");
			
			mainContextProvider.init();
		}
		


		
		override public function transitionOut():void 
		{
			super.transitionOut();
		
			transitionOutComplete();
		}
	}
}
