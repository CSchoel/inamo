package GraphicalErrors
    package PkgWithWildcardImports
        import GraphicalErrors.Icons.*;
        
        model OuterImport
            extends Rect;
            Rect rect annotation(Placement(transformation(extent={{-20,-20},{20, 20}})));
        end OuterImport;
    end PkgWithWildcardImports;

    package PkgWithExplicitImports
        import GraphicalErrors.Icons.Rect;
        
        model OuterImport
            extends Rect;
            Rect rect annotation(Placement(transformation(extent={{-20,-20},{20, 20}})));
        end OuterImport;
        
        model InnerImport
            import GraphicalErrors.Icons.Circle;
            extends Circle;
            Circle rect annotation(Placement(transformation(extent={{-20,-20},{20, 20}})));
        end InnerImport;
    end PkgWithExplicitImports;
    
    package Icons
        model Rect
            annotation(Icon(graphics={Rectangle(origin={0,0}, extent={{-100, -100},{100, 100}})}));
        end Rect;
        model Circle
            annotation(Icon(graphics={Ellipse(origin={0,0}, extent={{-100, -100},{100, 100}})}));
        end Circle;
    end Icons;
    
    model WithIconMap
        extends GraphicalErrors.Icons.Rect annotation(IconMap(extent={{-50,-50},{50, 50}}));
        extends GraphicalErrors.Icons.Circle;
    end WithIconMap;

    model IconMapAsComponent
        // Expected: Icon in diagram view is same as icon in tree view (small rectangle in large circle)
        // Actual: Icon in diagram view has same diameter for rectangle and circle
        WithIconMap myModel annotation(Placement(transformation(extent={{-20,-20},{20, 20}})));
    end IconMapAsComponent;

    model RedeclareBase
        replaceable model PrimitiveType = GraphicalErrors.Icons.Circle;
        PrimitiveType primitive annotation(Placement(transformation(origin={0, 0}, extent={{-50, -50},{50, 50}})));
    end RedeclareBase;
    
    model RedeclareClass
        // TODO check if this works with redeclaring components if we also re-add the annotation when we redeclare
        RedeclareBase rb(
            redeclare replaceable model PrimitiveType = GraphicalErrors.Icons.Rect
        );
    end RedeclareClass;

    model ShiftedCoordinateSystem
        annotation(
            Icon(
                coordinateSystem(
                    extent={{-50, -100}, {150, 100}}
                ),
                graphics={
                    Ellipse(origin={0,0}, extent={{-100, -100},{100, 100}})
                }
            )
        );
        extends GraphicalErrors.Icons.Circle;
    end ShiftedCoordinateSystem;

    model NonstandardIconExtent
        annotation(
            Icon(
                coordinateSystem(
                    extent={{-200, -200}, {200, 200}}
                ),
                graphics={
                    Ellipse(origin={0,0}, extent={{-200, -200},{200, 200}})
                }
            )
        );
    end NonstandardIconExtent;
end GraphicalErrors;