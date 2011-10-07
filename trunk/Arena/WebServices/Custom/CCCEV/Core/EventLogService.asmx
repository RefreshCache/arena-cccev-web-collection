<%@ WebService Language="C#" Class="EventLogService" %>

using System;
using System.Web.Script.Services;
using System.Web.Services;
using Arena.Core;
using Arena.Custom.Cccev.FrameworkUtils.Data;
using Arena.Custom.Cccev.FrameworkUtils.Entity;

[WebService(Namespace = "http://localhost/Arena")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]
public class EventLogService : WebService 
{
    private enum CrudOperationType { CREATE, READ, UPDATE, DELETE }
    private readonly IEventLogEntryRepository repository;
    
    public EventLogService() : this(new ArenaEventLogEntryRepository())
    {
    }
    
    public EventLogService(IEventLogEntryRepository repository)
    {
        this.repository = repository;
    }
    
    [WebMethod]
    public void LogDelete(int id, string name, string objectType) 
    {
        var user = ArenaContext.Current.User;
        
        if (!user.Identity.IsAuthenticated)
        {
            return;
        }

        var entry = new EventLogEntry(id, name, objectType, user.Identity.Name, DateTime.Now, CrudOperationType.DELETE.ToString());
        repository.LogEntry(entry);
    }
}

