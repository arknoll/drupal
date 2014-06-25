# encoding: utf-8
#
# Cookbook Name:: nmddrupal
# Attributes:: deploy
#
# Copyright:: 2014, newmedia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

default[:nmddrupal][:server][:base] = '/srv/www'

# set default web and files users
default[:nmddrupal][:server][:users][:web] = 'www-data:www-data'
default[:nmddrupal][:server][:users][:files] =
  node[:nmddrupal][:server][:users][:web]

# drupal specific settings
node[:nmddrupal][:sites].each do |name, _site|
  default[:nmddrupal][:sites][name][:active] = 0
  default[:nmddrupal][:sites][name][:deploy][:action] = []
  default[:nmddrupal][:sites][name][:deploy][:releases] = 5

  # default to bringing in latest drupal
  default[:nmddrupal][:sites][name][:repository][:host] = 'github.com'
  default[:nmddrupal][:sites][name][:repository][:uri] =
    'https://github.com/drupal/drupal.git'
  default[:nmddrupal][:sites][name][:repository][:revision] = '7.28'
  default[:nmddrupal][:sites][name][:repository][:shallow_clone] = false
end
