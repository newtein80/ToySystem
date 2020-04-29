using System;
using System.Collections.Generic;
using System.Text;

namespace ToySystem.Core.Events
{
    public class StoredEvent : Event
    {
        public Guid Id { get; private set; }

        public string Data { get; private set; }

        public string User { get; private set; }

        // EF Constructor
        protected StoredEvent() { }

        public StoredEvent(Event theEvent, string data, string user)
        {
            Id = Guid.NewGuid();
            AggregateId = theEvent.AggregateId; // Message
            MessageType = theEvent.MessageType; // Message
            Data = data;                        // constructor parameter
            User = user;                        // constructor parameter
        }
    }
}
