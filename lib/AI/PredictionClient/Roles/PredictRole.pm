use strict;
use warnings;
package AI::PredictionClient::Roles::PredictRole;

# ABSTRACT: Implements the Predict service specific interface

use AI::PredictionClient::Classes::SimpleTensor;

use Moo::Role;

requires 'request_ds', 'reply_ds';

sub inputs {
  my ($self, $inputs_href) = @_;

  my $inputs_converted_href;

  foreach my $inkey (keys %$inputs_href) {
    $inputs_converted_href->{$inkey} = $inputs_href->{$inkey}->tensor_ds;
  }

  $self->request_ds->{"inputs"} = $inputs_converted_href;

  return;
}

sub callPredict {
  my $self = shift;

  my $request_ref = $self->serialize_request();

  my $result_ref = $self->perception_client_object->callPredict($request_ref);

  return $self->deserialize_reply($result_ref);
}

sub outputs {
  my $self = shift;

  my $predict_outputs_ref = $self->reply_ds->{outputs};

  my $tensorsout_href;

  foreach my $outkey (keys %$predict_outputs_ref) {
    $tensorsout_href->{$outkey} = AI::PredictionClient::Classes::SimpleTensor->new(
      $predict_outputs_ref->{$outkey});
  }

  return $tensorsout_href;
}

1;

