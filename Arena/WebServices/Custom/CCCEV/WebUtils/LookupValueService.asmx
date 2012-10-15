<%@ WebService Language="C#" Class="LookupValueService" %>
/**********************************************************************
* Description:  The value of a lookup
* Created By:   Nick Airdo @ Central Christian Church (Cccev)
* Date Created:	04/5/2012 13:42:02
*
* $Workfile: LookupValueService.asmx $
* $Revision: 1 $ 
* $Header: /trunk/Arena/WebServices/Custom/CCCEV/WebUtils/LookupValueService.asmx   1   2012-04-11 13:35:57-07:00   nicka $
* 
* $Log: /trunk/Arena/WebServices/Custom/CCCEV/WebUtils/LookupValueService.asmx $
* 
* Revision: 1   Date: 2012-04-11 20:35:57Z   User: nicka 
* Simple hit counter module and service used for VBS 2012 
**********************************************************************/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Script.Services;
using System.Web.Services;
using Arena.Core;
using Arena.Utility; 

[WebService(Namespace = "http://localhost/Arena")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class LookupValueService : WebService
{
    [WebMethod]
    [ScriptMethod( ResponseFormat = ResponseFormat.Json, UseHttpGet = true )]
    public object GetValue( )
    {
        return GetValue( 1 );
    }
    
    [WebMethod]
    [ScriptMethod( ResponseFormat = ResponseFormat.Json, UseHttpGet = true )]
    public object GetValue( int lookupID )
    {
        int value = 0;
        try
        {
            Lookup pageLookup = new Lookup( lookupID, false );


            if ( pageLookup != null )
            {
                value = Convert.ToInt32( pageLookup.Qualifier );
            }

        }
        catch ( Exception ex )
        {
            // Log this as an error.
        }
        return new
        {
            count = value
        };
    }
}