use v6;

use PDF::DOM::Type::Catalog;
use PDF::Storage::Serializer;
use PDF::Writer;

class PDF::DOM
    is PDF::DOM::Type::Catalog {

    method save-as(Str $file-name!) {
        my $body = PDF::Storage::Serializer.new.body(self);
        my $root = $body<trailer><dict><Root>;
        my $ast = :pdf{ :version(1.2), :$body };
        my $writer = PDF::Writer.new( :$root );
        $file-name.IO.spurt( $writer.write( $ast ), :enc<latin-1> ), 'hello world';
    }
}
