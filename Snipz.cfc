<cfcomponent output="false">

	<cffunction name="init">
		<cfreturn this />
	</cffunction>	
	
	<cffunction name = "blurb" output="false"> 
		<cfargument name="bodyWithHTML">
		<cfargument name="keywords">
		<cfargument name="length">
		
		<cfset var keywordCenter  = "">
		<cfset var startPosition = "">
		<cfset var result = "">
		<cfset var body = stripHTML(bodyWithHTML)>
				
		<cfif len(body) lte length>
			<cfreturn highlightKeywords(body, arguments.keywords)>
		</cfif>
		
		<cfset keywordCenter  = findKeywordCenter(body, keywords, length)>
		<cfset startPosition = max(int(keywordCenter - length/2), 1)>
		<cfset result = mid(body, startPosition, length)>
	
		<!--- strip first word (or partial word) --->
		<cfif startPosition neq 1>
			<cfset result = "&hellip; " & reReplaceNoCase(result, "^\S+\s", "")>
		</cfif>
		
		<!--- strip last word (or partial word) --->
		<cfset result = reReplaceNoCase(result, " \S+$", "") & " &hellip;">
		
		<cfreturn highlightKeywords(result, arguments.keywords)>
		
	</cffunction>

	
	<cffunction name = "summarize" output="false">
		<cfargument name="htmlString">
		<cfargument name="length" default="155">
		<cfargument name="addElipse" default="true">
		<cfset var result = stripHTML(htmlString)>
		<cfif len(result) gt arguments.length>
			<cfset result = left(result, arguments.length + 1)>
			<cfset result = trim(reReplaceNoCase(result, " \S+$", ""))>
			<cfif arguments.addElipse>
				<cfset result = "#result#&hellip;">
			</cfif>
		</cfif>
		<cfreturn result>
	</cffunction>
	
	<cffunction name = "stripHTML" output="false">
		<cfargument name="htmlString">
		<cfreturn trim(ReReplaceNoCase(arguments.htmlString, "<[^>]*>", "", "ALL"))>
	</cffunction>
	
	<cffunction name = "findKeywordCenter" output="false">
		<cfargument name="body">
		<cfargument name="keywords">
		<cfargument name="length">

		<cfset var leftStack = arrayNew(1)>
		<cfset var rightStack = arrayNew(1)>	
		<cfset var startPosition = 1>
		<cfset var matchPosition = 0>
		<cfset var mostKeywords = -1>
		<cfset var mostKeywordsIndex = 1>
		<cfset var keywordCenter = 1>
		<cfset var keywordsFound = 0>
		<cfset var keyword = "">
		<cfset var result = "">


		<cfloop index = "keyword" list = "#arguments.keywords#">
			<cfloop condition = "true">
				<cfset matchPosition = reFindNoCase('\b#replace(keyword, "_", "\S", "all")#\b', body, startPosition)>
				
				<cfif matchPosition eq 0>
					<cfbreak>
				<cfelse>
					<cfset startPosition = matchPosition + len(keyword)>
					<cfset arrayAppend(leftStack, matchPosition)>
					<cfset arrayAppend(rightstack, startPosition)>
				</cfif>	
			</cfloop>	
		</cfloop>

		<cfloop condition = "arraylen(leftStack) gt 0">
			<cfloop condition = "arrayLen(rightStack) gt 0 and leftStack[1] + length gte rightStack[1]">
				<cfset keywordsFound = arrayLen(leftStack) - arrayLen(rightStack) + 1>
				<cfif keywordsFound gt mostKeywords>
					<cfset mostKeywords = keywordsFound>
					<cfset keywordCenter = leftStack[1] + (rightStack[1] - leftStack[1]) / 2>
				</cfif>
				<cfset arrayDeleteAt(rightStack, 1)>	
			</cfloop>
			<cfset arrayDeleteAt(leftStack,1)>
		</cfloop>
		
		
		<cfreturn keywordCenter>
	</cffunction>
	
	<cffunction name = "highlightKeywords" output="false">
		<cfargument name="body">
		<cfargument name="keywords">
		<cfargument name="starttag" default="<b>">
		<cfargument name="endtag" default="</b>">
		<cfset var keyword = "">
		<cfset var escapedKeyword = "">
		<cfset var result = body>
		<cfloop index = "keyword" list = "#arguments.keywords#">
			<cfset escapedKeyword = reReplaceNoCase(keyword, "[\[\]\(\)\*\?\+\{\}\\\-\|]", "\\\0", "all")>
			<cfset escapedKeyword = Replace(escapedKeyword, "_", "\S", "all")>
			<cfset result = reReplaceNoCase(result, "\b(#escapedKeyword#)\b(?![^<]+>)", "#startTag#\0#endTag#", "all")>
		</cfloop>
		<cfreturn result>
	</cffunction>
	
</cfcomponent>