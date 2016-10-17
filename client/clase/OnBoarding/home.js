Template.claseHome.helpers({
	title: function() {
		return RocketChat.settings.get('Layout_Home_Title');
	},
	children: function() {
		var query = {
			t: 'c',
			open: true,
			'clase.childName': { '$exists': true}
		};
		return ChatSubscription.find(query, { sort: {'clase.childName': 1} });
	}
});

Template.claseHome.onRendered(function() {
	$('#initial-page-loading').remove();
});

Template.claseHome.events({
	'click #clase_add': function() {
		SideNav.setFlex('joinSchoolClassRoom');
		SideNav.openFlex();
		menu.toggle();
	}
});
