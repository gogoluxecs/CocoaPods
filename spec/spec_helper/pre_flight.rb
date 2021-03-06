# Restores the config to the default state before each requirement

module Bacon
  class Context
    old_run_requirement = instance_method(:run_requirement)

    define_method(:run_requirement) do |description, spec|
      ::Pod::Config.instance = nil
      ::Pod::Config.instance.tap do |c|
        ENV['VERBOSE_SPECS'] ? c.verbose = true : c.silent = true
        c.repos_dir        =  fixture('spec-repos')
        c.project_root     =  SpecHelper.temporary_directory
        c.doc_install      =  false
        c.generate_docs    =  false
        c.skip_repo_update =  true
      end
      ::Pod::UI.output = ''
      # Very nasty behaviour where the relative increments are
      # not reverted and lead to sections being collapsed and
      # not being printed to the output.
      ::Pod::UI.indentation_level = 0
      ::Pod::UI.title_level = 0

      old_run_requirement.bind(self).call(description, spec)
    end
  end
end

