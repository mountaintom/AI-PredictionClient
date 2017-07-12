use strict;
use warnings;
package AI::PredictionClient::InceptionClient;


# ABSTRACT: A module implementing the TensorFlow Serving Inception client

use 5.010;

use Data::Dumper;
use Moo;

use AI::PredictionClient::Classes::SimpleTensor;
use AI::PredictionClient::Testing::Camel;

extends 'AI::PredictionClient::Predict';

has inception_results => (is => 'rwp');

has camel => (is => 'rw',);

sub call_inception {
  my $self  = shift;
  my $image = shift;

  my $tensor = AI::PredictionClient::Classes::SimpleTensor->new();
  $tensor->shape([ { size => 1 } ]);
  $tensor->dtype("DT_STRING");

  if ($self->camel) {
    my $camel_test = AI::PredictionClient::Testing::Camel->new();
    $tensor->value([ $camel_test->camel_jpeg_ref ]);
  } else {
    $tensor->value([$image]);
  }

  $self->inputs({ images => $tensor });

  if ($self->callPredict()) {

    my $predict_output_map_href = $self->outputs;
    my $inception_results_href;

    foreach my $key (keys %$predict_output_map_href) {
      $inception_results_href->{$key} = $predict_output_map_href->{$key}
        ->value;  #Because returns Tensor objects.
    }

    $self->_set_inception_results($inception_results_href);

    return 1;
  } else {
    return 0;
  }

}

1;

