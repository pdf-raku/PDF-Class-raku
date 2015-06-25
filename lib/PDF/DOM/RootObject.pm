use v6;

role PDF::DOM::RootObject {

    use PDF::Storage::Serializer;
    use PDF::Reader;
    use PDF::Writer;

    #| open an input file
    method open(Str $file-name) {
        my $reader = PDF::Reader.new;
        $reader.open($file-name);
        $reader.root.object;
    }

    #| perform an incremental save back to the opened input file
    method update {
        my $reader = $.reader;

        die "pdf file has not been previously opened"
            unless $reader.defined && $reader.file-name.defined;
 
        # todo we should be able to leave the input file open and append to it
        my $offset = $reader.input.chars + 1;
        $reader.input.?close;

        my $serializer = PDF::Storage::Serializer.new;
        my $body = $serializer.body( $reader, :updates );
        my $root = $reader.root;
        my $prev = $body<trailer><dict><Prev>.value;
        my $writer = PDF::Writer.new( :$root, :$offset, :$prev );
        my $new-body = "\n" ~ $writer.write( :$body );
        $reader.file-name.IO.open(:a).write( $new-body.encode('latin-1') );
    }

    #| do a full save to the named file
    method save-as(Str $file-name!,
                   :$version is copy,  #| e.g. 1.3
                   :$type is copy,     #| e.g. 'PDF', 'FDF;
        ) {

        if $.reader.defined {
            $version //= $.reader.version;
            $type //= $.reader.type;
        }
        else {
            $version //= 1.3;
            $type //= 'PDF';
        }

        my $body = PDF::Storage::Serializer.new.body(self);
        my $root = $body<trailer><dict><Root>;
        my $ast = :pdf{ :header{ :$type, :$version }, :$body };
        my $writer = PDF::Writer.new( :$root );
        $file-name.IO.spurt( $writer.write( $ast ), :enc<latin-1> );
    }
}
