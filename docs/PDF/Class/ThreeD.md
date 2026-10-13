[[Raku PDF Project]](https://pdf-raku.github.io)
 / [[PDF-Class Module]](https://pdf-raku.github.io/PDF-Class-raku)

### has PDF::Class::ThreeD::DefaultView $.default-view

(Optional) An object that specifies the default initial view of the 3D artwork that shall be used when the annotation is activated. It may be either a 3D view dictionary or one of the following types:



3D Activation dictionary

### has Mu $.A

[name] (Optional) A name specifying the circumstances under which the annotation is activated. Valid values are:

### has PDF::Class::ThreeD::ThreeDActivation::ActivationState $.AIS

[name] (Optional) A name specifying the state of the artwork instance upon activation of the annotation. Valid values are:

### has PDF::Class::ThreeD::ThreeDActivation::DeactiviationCircumstances $.D

[name] (Optional) A name specifying the circumstances under which the annotation is deactivated. Valid values are:

### has Mu $.DIS

[name] (Optional) A name specifying the state of the artwork instance upon deactivation of the annotation. Valid values are U (uninstantiated), I(instantiated), and L (live). Default value: U.

### has Bool $.TB

[boolean] (Optional; PDF 1.7) A flag indicating the default behavior of an interactive toolbar associated with this annotation. If true, a toolbar is displayed by default when the annotation is activated and given focus. If false, a toolbar shall not be displayed by default.

### has Bool $.NP

Default value: false

### has PDF::Class::ThreeD::ThreeDActivation $.activation

dictionary (Optional) An activation dictionary that defines the times at which the annotation shall be activated and deactivated and the state of the 3D artwork instance at those times.

