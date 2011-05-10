package com.code11.notification
{
	import flash.display.Screen;
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	
	public class WindowGroup extends Group
	{
		private var openNotifications:Array = [];
		override public function getElementAt(index:int):IVisualElement {
			return openNotifications[index];
		}
		
		override public function get numElements():int {
			return openNotifications.length;
		}
		
		override public function addElement(element:IVisualElement):IVisualElement {
			openNotifications.push(element);
			element.addEventListener(FlexEvent.UPDATE_COMPLETE,onUpdate);
			layout.updateDisplayList(width,height);
			return element;
		}
		
		override public function removeElement(element:IVisualElement):IVisualElement {
			openNotifications.splice(openNotifications.indexOf(element),1);
			element.removeEventListener(FlexEvent.UPDATE_COMPLETE,onUpdate);
			layout.updateDisplayList(width,height);
			return element;
		}
		
		private function onUpdate(e:Event):void {
			layout.updateDisplayList(width,height);
		}
		
		public function WindowGroup()
		{
			super();
		}
	}
}