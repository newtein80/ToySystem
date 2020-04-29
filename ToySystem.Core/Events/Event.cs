using MediatR;
using System;
using System.Collections.Generic;
using System.Text;

namespace ToySystem.Core.Events
{
    public abstract class Event : Message, INotification
    {
        public DateTime Timestamp { get; private set; }

        protected Event()
        {
            Timestamp = DateTime.Now;
        }
    }
}
/*
public class NewUser : INotification  
{  
    public string Username { get; set; }  
    public string Password { get; set; }  
} 


public class NewUserHandler : INotificationHandler<NewUser>  
{  
    public Task Handle(NewUser notification, CancellationToken cancellationToken)  
    {  
        //Save to log  
        Debug.WriteLine(" ****  Save user in database  *****");  
        return Task.FromResult(true);  
    }  
}


public class EmailHandler : INotificationHandler<NewUser>  
{  
    public Task Handle(NewUser notification, CancellationToken cancellationToken)  
    {  
        //Send email  
        Debug.WriteLine(" ****  Email sent to user  *****");  
        return Task.FromResult(true);  
    }  
}  


public class LogHandler : INotificationHandler<NewUser>  
{  
    public Task Handle(NewUser notification, CancellationToken cancellationToken)  
    {  
        //Save to log  
        Debug.WriteLine(" ****  User save to log  *****");  
        return Task.FromResult(true);  
    }  
}


public class AccountsController : Controller  
{  
    private readonly IMediator _mediator;  
    public AccountsController(IMediator mediator)  
    {  
        _mediator = mediator;  
    }  

    [HttpGet]  
    public ActionResult Login()  
    {  
        return View();  
    }  

    [HttpGet]  
    public ActionResult Register()  
    {  
        return View();  
    }  
  
    [HttpPost]  
    public ActionResult Register(NewUser user)  
    {  
        _mediator.Publish(user);  
        return RedirectToAction("Login");  
    }  
}
*/
