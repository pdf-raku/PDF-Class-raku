use PDF::Graphics::Contents;
role PDF::Doc::Contents does PDF::Graphics::Contents {

    method graphics-class {
        use PDF::Doc::Graphics;
        PDF::Doc::Graphics
    }
}
