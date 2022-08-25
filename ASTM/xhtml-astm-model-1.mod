<!-- ....................................................................... -->
<!-- ASTN XHTML 1.0 Document Model Module  ...................................... -->
<!--
     This DTD module is identified by the PUBLIC and SYSTEM identifiers:

     PUBLIC "+//ASTM//ENTITIES ASTM XHTML Document Model 1.0//EN"
     SYSTEM "xhtml-astm-model-1.mod"

     Revisions:
     (none)
     ....................................................................... -->

<!-- Document Model

     This module describes the groupings of elements that make up
     common content models for XHTML elements.

     XHTML has three basic content models:

         %Inline.mix;  character-level elements
         %Block.mix;   block-like elements, eg., paragraphs and lists
         %Flow.mix;    any block or inline elements

     Any parameter entities declared in this module may be used
     to create element content models, but the above three are
     considered 'global' (insofar as that term applies here).

     The reserved word '#PCDATA' (indicating a text string) is now
     included explicitly with each element declaration that is
     declared as mixed content, as XML requires that this token
     occur first in a content model specification.
-->
<!-- Extending the Model

     While in some cases this module may need to be rewritten to
     accommodate changes to the document model, minor extensions
     may be accomplished by redeclaring any of the three *.extra;
     parameter entities to contain extension element types as follows:

         %Misc.extra;    whose parent may be any block or
                         inline element.

         %Inline.extra;  whose parent may be any inline element.

         %Block.extra;   whose parent may be any block element.

     If used, these parameter entities must be an OR-separated
     list beginning with an OR separator ("|"), eg., "| a | b | c"

     All block and inline *.class parameter entities not part
     of the *struct.class classes begin with "| " to allow for
     exclusion from mixes.
-->

<!-- ..............  Optional Elements in head  .................. -->

<!ENTITY % Head-opts.mix  "" >

<!-- .................  Miscellaneous Elements  .................. -->

<!-- ins and del are used to denote editing changes
-->
<!ENTITY % Edit.class "| ins | del" >

<!-- script and noscript are used to contain scripts
     and alternative content
-->

<!ENTITY % Misc.extra "" >

<!-- These elements are neither block nor inline, and can
     essentially be used anywhere in the document body.
-->
<!ENTITY % Misc.class "%Edit.class;">
<!--      %Misc.extra;"
-->

<!-- ....................  Inline Elements  ...................... -->

<!ENTITY % Inlstruct.class "br | span" >

<!ENTITY % Inlphras.class
     "| em | strong | dfn | code | samp | kbd | var | cite | abbr | acronym | q" >

<!ENTITY % Inlpres.class
     "| tt | i | b | big | small | sub | sup" >

<!ENTITY % I18n.class "| bdo" >

<!ENTITY % Anchor.class "| a" >

<!ENTITY % Inlspecial.class "| img" >

<!ENTITY % Inline.extra 
     "" >

<!ENTITY % Ruby.class "| ruby" >

<!-- %Inline.class; includes all inline elements,
     used as a component in mixes
-->
<!ENTITY % Inline.class
     "%Inlstruct.class;
      %Inlphras.class;
      %Inlpres.class;
      %I18n.class;
      %Anchor.class;
      %Inlspecial.class;
      %Ruby.class;
      %Inline.extra;"
>

<!-- %Inline-noruby.class; includes all inline elements 
     except ruby, used as a component in mixes

<!ENTITY % Inline-noruby.class
     "%Inlstruct.class;
      %Inlphras.class;
      %Inlpres.class;
      %I18n.class;
      %Anchor.class;
      %Inlspecial.class;
      %Inline.extra;"
>
-->
<!-- %Noruby.content; includes all inlines except ruby

<!ENTITY % Noruby.content
     "( #PCDATA 
      | %Inline-noruby.class;
      %Misc.class; )*"
>
-->
<!-- %Inline-noa.class; includes all non-anchor inlines,
     used as a component in mixes

<!ENTITY % Inline-noa.class
     "%Inlstruct.class;
      %Inlphras.class;
      %Inlpres.class;
      %I18n.class;
      %Inlspecial.class;
      %Ruby.class;
      %Inline.extra;"
>
-->
<!-- %Inline-noa.mix; includes all non-anchor inlines

<!ENTITY % Inline-noa.mix
     "%Inline-noa.class;
      %Misc.class;"
>
-->
<!-- %Inline.mix; includes all inline elements, including %Misc.class;
-->
<!ENTITY % Inline.mix
     "%Inline.class;
      %Misc.class;"
>

<!-- .....................  Block Elements  ...................... -->

<!-- In the HTML 4.0 DTD, heading and list elements were included
     in the % block; parameter entity. The % Heading.class; and
     % List.class; parameter entities must now be included explicitly
     on element declarations where desired.
-->

<!ENTITY % Heading.class "h1 | h2 | h3 | h4 | h5 | h6" >

<!ENTITY % List.class "ul | ol | dl" >

<!ENTITY % Blkstruct.class "p | div" >

<!ENTITY % Blkphras.class "| pre | blockquote | address" >

<!ENTITY % Blkpres.class "| hr" >

<!ENTITY % Block.extra "| table  | fieldset" >

<!-- %Block.class; includes all block elements,
     used as an component in mixes
-->
<!ENTITY % Block.class
     "%Blkstruct.class;
      %Blkphras.class;
      %Blkpres.class;
      %Block.extra;"
>

<!-- %Block.mix; includes all block elements plus %Misc.class;
-->
<!ENTITY % Block.mix
     "%Heading.class;
      | %List.class;
      | %Block.class;
      %Misc.class;"
>

<!-- ................  All Content Elements  .................. -->

<!-- %Flow.mix; includes all text content, block and inline
-->
<!ENTITY % Flow.mix
     "%Heading.class;
      | %List.class;
      | %Block.class;
      | %Inline.class;
      %Misc.class;"
>

<!-- end of xhtml11-model-1.mod -->
