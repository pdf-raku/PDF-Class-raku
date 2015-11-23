use v6;

role PDF::DOM::Resources {

    method core-font(|c) {
	(self.Resources //= {}).core-font(|c);
    }

    method resource(|c) {
	(self.Resources //= {}).resource(|c);
    }

    method resource-entry(|c) {
	my $resources = self.Resources
	    // return;

        $resources.resource-entry(|c);
    }

    method !find-resource( |c ) {
        my $resources = self.Resources
	    // return;

	$resources.find-resource(|c);
    }

}
