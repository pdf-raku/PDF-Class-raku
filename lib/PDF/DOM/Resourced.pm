use v6;

role PDF::DOM::Resourced {

    method core-font(|c) {
	(self.Resources //= {}).core-font(|c);
    }

    #| ensure that object is registered as a resource
    method use-resource($obj, |c) {
	(self.Resources //= {}).resource($obj, |c);
    }

    #| my %fonts = $doc.page(1).resources('Font');
    multi method resources('ProcSet') {
	my @entries;
	my $resources = self.Resources;
	my $resource-entries = $resources.ProcSet
	    if $resources;
	@entries = $resource-entries.keys.map( { $resource-entries[$_] } )
	    if $resource-entries;
	@entries;	
    }
    multi method resources(Str $type) is default {
	my %entries;
	my $resources = self.Resources;
	my $resource-entries = $resources."$type"()
	    if $resources;
	%entries = $resource-entries.keys.map( { $_ => $resource-entries{$_} } )
	    if $resource-entries;
	%entries;
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
