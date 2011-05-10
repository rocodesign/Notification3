package com.code11.notification {
	import com.code11.ds.KeyedCollection;
	
	import flash.display.Screen;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.core.IVisualElement;
	
	import spark.components.Group;
	import spark.layouts.HorizontalAlign;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalAlign;
	import spark.layouts.VerticalLayout;
	import spark.layouts.supportClasses.LayoutBase;
	import spark.primitives.Rect;
	
	
	public class NotificationManager {
		
		private var notificationGroups:KeyedCollection;
		
		private var pendingNotifications:Array = [];
		private var openNotifications:Array = [];
		
		public var defaultNotificationGroup:WindowGroup;
		public var maxNotifications:int = 3;
		
		public function NotificationManager() {
			notificationGroups = new KeyedCollection('name');
			
			var sb:Rectangle = Screen.mainScreen.visibleBounds;
			
			defaultNotificationGroup = new WindowGroup();
			defaultNotificationGroup.name = "default";
			defaultNotificationGroup.width = sb.width;
			defaultNotificationGroup.height = sb.height;
			var vl:VerticalLayout = new VerticalLayout();
			vl.paddingLeft = vl.paddingTop = 5;
			vl.gap = 0;
			defaultNotificationGroup.layout = vl;
			notificationGroups.addItem(defaultNotificationGroup);
			
			var topRightGroup:WindowGroup = new WindowGroup();
			topRightGroup.width = sb.width;
			topRightGroup.height = sb.height;
			topRightGroup.name = "topRight";
			var hl:HorizontalLayout = new HorizontalLayout();
			hl.paddingLeft = hl.paddingTop = hl.paddingBottom = hl.paddingRight = 5;
			hl.horizontalAlign = HorizontalAlign.RIGHT;
			hl.gap = 0;
			topRightGroup.layout = hl;
			notificationGroups.addItem(topRightGroup);
			
			var bottomRightGroup:WindowGroup = new WindowGroup();
			bottomRightGroup.name = "bottomRight";
			bottomRightGroup.width = sb.width;
			bottomRightGroup.height = sb.height;
			vl = new VerticalLayout();
			vl.paddingLeft = vl.paddingTop = vl.paddingBottom = vl.paddingRight = 5;
			vl.gap = 0;
			vl.verticalAlign = VerticalAlign.BOTTOM;
			vl.horizontalAlign = HorizontalAlign.RIGHT;
			bottomRightGroup.layout = vl;
			notificationGroups.addItem(bottomRightGroup);
		}
		
		public function addNotification(notification:Notification,groupName:String = "default"):void {
			var notificationGroup:Group = notificationGroups.getItemByKey(groupName) as Group;
			var notificationByName:Notification = notificationGroup.getChildByName(notification.name) as Notification;
			if (notificationByName) {
				return;
			}
			for (var i:int = 0; i < pendingNotifications.length; i++) {
				var pendingnot:Notification = pendingNotifications[i];
				if (pendingnot.name == notification.name) {
					return;
				}
			}
			pendingNotifications.push(notification);
			notification.addEventListener(Event.OPEN,onOpen);
			notification.addEventListener(Notification.SHOWN,showNext);
			if (openNotifications.length < maxNotifications) {
				pendingNotifications.shift().open(true);
			}
		}
		
		public function removeNotification(name:String,groupName:String = "default"):void {
			var notification:Notification = notificationGroups.getItemByKey(groupName).getChildByName(name) as Notification;
			if (notification) {
				notification.close();
				return;
			}
			for (var i:int = 0; i < pendingNotifications.length; i++) {
				notification = pendingNotifications[i];
				if (notification.name == name) {
					pendingNotifications.splice(i,1);
					return;
					
				}
			}
		}
		
		private function onOpen(e:Event):void {
			var not:Notification = e.target as Notification;
			not.addEventListener(Event.CLOSE,onClose);
			not.addEventListener(Event.RESIZE,notificationResized);
			openNotifications.push(not);
			(notificationGroups.getItemByKey(not.groupName) as Group).addElement(not);
			//topRightLayout.updateDisplayList(Screen.mainScreen.visibleBounds.width,Screen.mainScreen.visibleBounds.height);
		}
		
		private function notificationResized(e:Event):void {
			/*for (var i:int = 0; i < openNotifications.length; i++) {
				var not:Notification = openNotifications[i];
				if (i == 0) not.move(0,0);
				else not.move(0,openNotifications[i-1].y + openNotifications[i-1].height)
			}
			*/
		}
		
		private function onClose(e:Event):void {
			var not:Notification = e.target as Notification;
			openNotifications.shift();
			(notificationGroups.getItemByKey(not.groupName) as Group).removeElement(not);
			showNext(null);
		}
		
		private function showNext(e:Event):void {
			if (pendingNotifications.length) {
				var nextNotification:Notification = pendingNotifications.shift();
				nextNotification.open(true);
			}
		}
		
		public function getElementAt(index:int):IVisualElement {
			return openNotifications[index];
		}
		
		public function get numElements():int {
			return openNotifications.length;
		}
		
		public static function addGroup(group:WindowGroup,name:String = ""):void {
			instance.notificationGroups.addItem(group);
		}
		
		private static var instance:NotificationManager;
		public static function getInstance():NotificationManager {
			if (!instance) instance = new NotificationManager();
			return instance;
		}
		
		
	}
}