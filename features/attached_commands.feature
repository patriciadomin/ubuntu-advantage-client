
@uses.config.contract_token
Feature: Command behaviour when attached

    @test
    Scenario: Attached refresh in a trusty lxd container
	Given a trusty lxd container with ubuntu-advantage-tools installed
        When I attach contract_token with sudo 
	And I run `ua refresh` as non-root
	Then I will see the following on stderr:
	    """
	    This command must be run as root (try using sudo)
	    """
	    #When The machine is attached
        When I run `ua refresh` with sudo
        Then I will see the following on stdout:
            """
            Successfully refreshed your subscription
            """

    Scenario: Attached disable of a known service in a trusty lxd container
        Given a trusty lxd container with ubuntu-advantage-tools installed	
	When I attach contract_token with sudo
	And I run `ua disable livepatch` as non-root
        Then I will see the following on stderr:
            """
            This command must be run as root (try using sudo)
            """
        When I run `ua disable livepatch` with sudo
	Then I will see the following on stdout:
	    """
	    Livepatch is not currently enabled
	    See: sudo ua status
	    """

    Scenario: Attached disable of an unknown service in a trusty lxd container
        Given a trusty lxd container with ubuntu-advantage-tools installed
	When I attach contract_token with sudo	
	And I run `ua disable foobar` as non-root
        Then I will see the following on stderr:
            """
            This command must be run as root (try using sudo)
            """
        When I run `ua disable foobar` with sudo
        Then I will see the following on stderr:
            """
            Cannot disable 'foobar'
            For a list of services see: sudo ua status
	    """
    
    @esm
    Scenario: Attached disable of a known enabled service in a trusty lxd container
        Given a trusty lxd container with ubuntu-advantage-tools installed
	When I attach contract_token with sudo
	And I run `ua disable esm-infra` as non-root
        Then I will see the following on stderr:
            """
            This command must be run as root (try using sudo)
            """
        When I run `ua disable esm-infra` with sudo
        Then I will see the following on stdout:
            """
            Updating package lists
	    """
	When I run `ua status` with sudo
	Then stdout matches regexp:
	    """
	    esm-infra    +yes      +disabled +UA Infra: Extended Security Maintenance
	    """
 

    @detach
    Scenario: Attached detach in a trusty lxd container
        Given a trusty lxd container with ubuntu-advantage-tools installed
	When I attach contract_token with sudo
	And I run `ua detach` as non-root
        Then I will see the following on stderr:
            """
            This command must be run as root (try using sudo)
            """
        When I run `ua detach --assume-yes` with sudo
	Then I will see the following on stdout:
            """
            Detach will disable the following service:
                esm-infra
            Updating package lists
            This machine is now detached
	    """
