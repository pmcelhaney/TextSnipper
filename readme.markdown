# Snipz.cfc

Utility for creating snippets of documents on a search results page. The main
function, blurb(), takes a document/article body, a keyword, and a snippet
length, and produces a snippet containing the keyword(s).
        
If there are multiple keyword matches in the body, it finds the "best" snippet -- 
that is, the one matching the most keywords.                        

It also takes care of other little annoyances, such as stripping HTML and starting
and stopping at word boundaries.

### Example
              
    <cfoutput>#snipz.blurb(articleBody, "kobe,lakers", 600)#</cfoutput>
          
> &hellip; potentially more lucrative than in China.&rdquo; Nike
> is sponsoring a James museum in Beijing, but he &ldquo;lags well
> behind&rdquo; <b>Lakers</b> G <b>Kobe</b> Bryant in terms of
> popularity in the country. Rovell: &ldquo;<b>Kobe</b> is clearly
> bigger than LeBron. I&rsquo;d say he&rsquo;s at least two times
> bigger, and the reason for that is that Chinese really do &hellip;
