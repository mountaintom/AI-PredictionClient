use strict;
use warnings;
package AI::PredictionClient::Predict;


# ABSTRACT: The Predict service client

use Moo;
with 'AI::PredictionClient::Roles::PredictionRole',
  'AI::PredictionClient::Roles::PredictRole';
1;
