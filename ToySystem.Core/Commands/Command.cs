using FluentValidation.Results;
using System;
using System.Collections.Generic;
using System.Text;
using ToySystem.Core.Events;

namespace ToySystem.Core.Commands
{
    /// <summary>
    /// Event 클래스와는 다름 (Event : Message)
    /// Command 와 관련된 Request 관련 property 설정
    /// CUD(Command) 와 관련된 Request 설정, CUD 는 Validation 도 해야하기 때문에 ValidationResult 도 필요
    /// </summary>
    public abstract class Command : Message
    {
        public DateTime Timestamp { get; private set; }
        public ValidationResult ValidationResult { get; set; }

        protected Command()
        {
            Timestamp = DateTime.Now;
        }

        public abstract bool IsValid();
    }

    /*
        public abstract class Event : Message, INotification
        {
            public DateTime Timestamp { get; private set; }

            protected Event()
            {
                Timestamp = DateTime.Now;
            }
        }


        public abstract class Message : IRequest
        {
            public string MessageType { get; protected set; }
            public Guid AggregateId { get; protected set; }

            protected Message()
            {
                MessageType = GetType().Name;
            }
        }
     */
}

/*
// Fluent Validation 의 사용
using FluentValidation;

// Validator 생성
public class CustomerValidator: AbstractValidator<Customer> {
  public CustomerValidator() {
    RuleFor(x => x.Surname).NotEmpty();
    RuleFor(x => x.Forename).NotEmpty().WithMessage("Please specify a first name");
    RuleFor(x => x.Discount).NotEqual(0).When(x => x.HasDiscount);
    RuleFor(x => x.Address).Length(20, 250);
    RuleFor(x => x.Postcode).Must(BeAValidPostcode).WithMessage("Please specify a valid postcode");
  }

  private bool BeAValidPostcode(string postcode) {
    // custom postcode validating logic goes here
  }
}

// Validator 사용
var customer = new Customer();
var validator = new CustomerValidator();
ValidationResult results = validator.Validate(customer);

bool success = results.IsValid;
IList<ValidationFailure> failures = results.Errors;
*/
