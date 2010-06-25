# TextSnipper.cfc

Utility for creating snippets of documents on a search results page.

Tell it how long you want your snippet to be (in characters) and what keywords
to find/highlight. Pass an HTML string to the `snip()` function and it will
return a relevant substring with keywords highlighted. It takes care of 
little annoyances: stripping unwanted HTML, starting and stopping at word 
boundaries, and adding ellipses where necessary.
                           

## Example
    
		<cfset snipper = createObject("component", "TextSnipper")>
		<cfset snipper.setMaxLength(600)>    	
		<cfset snipper.setKeywords("Kobe,LeBron")>  
		<cfoutput>#snipper.snip(articleBody)#</cfoutput>
          
> &hellip; Lakers G <b>Kobe</b> Bryant in terms of popularity in
> the country. Rovell: &ldquo;<b>Kobe</b> is clearly bigger than
> <b>LeBron</b>. I&rsquo;d say he&rsquo;s at least two times
> bigger, and the reason for that is that Chinese really do respect
> a champion.&rdquo; Rhoads: &ldquo;For <b>LeBron</b> and Team
> <b>LeBron</b>, the ultimate objective has to be to get those rings
> onto <b>LeBron</b>&rsquo;s &hellip;      


## Notes

* `setMaxLength()` is optional. The default maxLength is 250 characters.
* `setKeywords()` is optional. If no keywords are found, the first part of the text will be snipped.
* It's chainable:	`#snipper.setMaxLength(300).setKeywords("foo,bar").snip()#`

