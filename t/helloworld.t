use v6;
use Test;

use PDF::DOM::Type::Catalog;
use PDF::Storage::Serializer;
use PDF::Writer;

my $pdf = PDF::DOM::Type::Catalog.new;
my $page = $pdf.Pages.add-page;
my $gfx = $page.gfx;
my $header-font = $page.core-font( :family<Helvetica>, :weight<bold> );
my $font = $page.core-font( :family<Helvetica> );
my $width = 300;
my $font-size = 15;

$gfx.ops.push('Td' => [ :real(50), :real(750) ]);

for <left center right justify> -> $align {
    my $header = [~] '*** ALIGN:', "\c[NO-BREAK SPACE]", $align, ' ***', "\n";
    my $body = q:to"--ENOUGH!!--".subst(/\n/, ' ', :g);
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt
        ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
        laboris nisi ut aliquip ex ea commodo consequat.
        --ENOUGH!!--

    note "% **** $align *** ";
    $gfx.text( $header, :font($header-font), :font-size(18), :$width, :$align);
    my $text-block = $gfx.text( $body, :$font, :$font-size, :$width, :$align, :kern);
    isa-ok $text-block, ::('PDF::DOM::Composition::Text::Block');
$gfx.ops.push: 'T*';

}

my $body = PDF::Storage::Serializer.new.body($pdf);
my $root = $body<trailer><dict><Root>;
my $ast = :pdf{ :version(1.2), :$body };
my $writer = PDF::Writer.new( :$root );
ok 't/helloworld.pdf'.IO.spurt( $writer.write( $ast ), :enc<latin-1> ), 'hello world';

done;
