Weclome to Nijito's documenation!
You may also be interested in [the Youtube videos](https://youtube.com/playlist?list=PLP0-2ozLHYqm0sCnDsw0av7OIC4VGVxvx).

If You're a Writer
------------------
These are the pages that you'll want to see:
 * [The dialogue system overview](@ref Dialogue) (just see the description at the bottom of the page)
 * [The character command docs](@ref Dialogue.VN.CharacterCommands)
 * [The stage command docs](@ref Dialogue.VN.StageCommands)


If You're a Programmer
----------------------
Currently, only a small subset of the code is being scanned by Doxygen.
This is to keep clutter down to a minimum. (Also one of our files is
causing Doxygen to crash for some reason?) Feel free to add more to the
Doxyfile if you feel it's necessary.

The content of this page is being stored in `docsRsrc/mainPage.md`.

If you wish to update these webpages, please re-run Doxygen. This can be done in few ways:
 * With [make](https://www.gnu.org/software/make/): Run `make` while in the `docsRsrc` folder.
 * Without make: Delete `docs`, and then run `doxygen` in the `docsRsrc` folder.
   Move stuff around to make sure it works with GitHub Pages. (Open up `Makefile` to see a list of steps.)
 * With Doxywizard: You're on your own; see above.

Once you've rebuilt the docs, you can check them by opening `docs/index.html`. 


If You're Someone Else
----------------------
There's probably nothing here for you (yet!). This has been created
mostly just for the writers to refer to.


