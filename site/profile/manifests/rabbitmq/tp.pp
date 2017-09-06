# profile::rabbitmq::tp
#
# @summary This profile manages rabbitmq with Tiny Puppet (tp)
#
# @example Include in other classes
#   include profile::rabbitmq::tp
# 
# @example Include in PSICK via hiera (yaml)
#   profiles:
#     - profile::rabbitmq::tp
# 
# @example Manage extra configs via hiera (yaml)
#   profile::rabbitmq::tp::ensure: present
#   profile::rabbitmq::tp::conf_hash:
#     rabbitmq.conf:
#       epp: profile/rabbitmq/rabbitmq.conf.epp
#     dot.conf:
#       epp: profile/rabbitmq/dot.conf.epp
#       base_dir: conf
#
# @param ensure If to install or remove rabbitmq
# @param conf_hash An hash to be passed to tp::conf to create configuration
#   files for rabbitmq. Check tp::conf parameters for available values.
# @param dir_hash An hash to be passed to tp::dir to create directories
#   for rabbitmq. Check tp::dir parameters for available values.
#   Hash looked up in deep merge mode.
# @param options_hash An open hash of options to use in the templates referenced
#   in the $conf_hash. This is passed as parameter to all the tp::conf defines.
#   Note, if an options_hash is set also in the $conf_hash that gets precedence.
#   It's looked up via a deep merge hash
# @param auto_prereq If to automatically install eventual dependencies for rabbitmq.
#   Set to false if you have problems with duplicated resources, being sure that you 
#   manage the prerequistes to install rabbitmq (other packages, repos or tp installs).
class profile::rabbitmq::tp (
  Enum['present','absent'] $ensure       = 'present',
  Hash                     $conf_hash    = {},
  Hash                     $dir_hash     = {},
  Hash                     $options_hash = {},
  Boolean                  $auto_prereq  = true,
) {

  # tp::install rabbitmq
  $install_defaults = {
    ensure             => $ensure,
    options_hash       => $options_hash,
    auto_repo          => $auto_prereq,
    auto_prerequisites => $auto_prereq,
  }
  ::tp::install { 'rabbitmq':
    * => $install_defaults,
  }

  # tp::conf iterated over $conf_hash
  $conf_defaults = {
    ensure             => $ensure,
    options_hash       => $options_hash,
  }
  $conf_hash.each | $k,$v | {
    ::tp::conf { "rabbitmq::${k}":
      * => $conf_defaults + $v,
    }
  }

  # tp::dir iterated over $dir_hash
  $dir_defaults = {
    ensure             => $ensure,
  }
  $dir_hash.each | $k,$v | {
    ::tp::dir { "rabbitmq::${k}":
      * => $dir_defaults + $v,
    }
  }

}
