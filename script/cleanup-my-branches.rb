#!/usr/bin/env ruby

def namespace
  @namespace ||= (
    ARGV[0] || `git config user.namespace`.chomp("\n")
  )
end

def branch_is_empty? branch
  `git log --oneline origin/master..#{branch}`.chomp("\n").empty?
end

def local_branches
  @local_branches ||= (
    `git branch --no-color`.split.map do |line|
      line.gsub(/^\*\s*/, '')
    end.select do |branch|
      branch.start_with? "#{namespace}/"
    end
  )
end

def remote_branches
  @remote_branches ||= (
    `git branch -r --no-color`.split.map do |line|
      line.gsub(/^\*\s*/, '')
    end.select do |branch|
      branch.start_with? "origin/#{namespace}/"
    end
  )
end

def local_branches_fully_merged
  @local_branches_fully_merged ||= (
    local_branches.select{|b| branch_is_empty? b}
  )
end

def remote_branches_fully_merged
  @remote_branches_fully_merged ||= (
    remote_branches.select{|b| branch_is_empty? b}
  )
end


def local_branch_kill_command
  unless local_branches_fully_merged.empty?
    "git b -D #{local_branches_fully_merged.join(' ')}"
  end
end

def remote_branch_kill_command
  branch_delete_refspecs = remote_branches_fully_merged.map do |branch|
    ":refs/heads/#{branch.gsub %r{^origin/}, ''}"
  end
  unless branch_delete_refspecs.empty?
    "git push origin #{branch_delete_refspecs.join(' ')}"
  end
end



if namespace.empty?
  puts "
    No user namespace specified.  Set one with

      git config user.namespace NAMESPACE

    or specify one on the command line with

      #{__FILE__} NAMESPACE
  ".gsub /^ {4}/, ''
  exit 1
end

if ARGV.include? '--help'
  puts "Prunes merged branches locally and on remote.
  Will not remove un-merged changes.
  To see what branches will be removed run with '--dry-run'.

  Usage: ruby ./cleanup-my-branches.rb [namespace] [--dry-run]
  "
  exit 0
end

cmds = [ local_branch_kill_command, remote_branch_kill_command ].compact
if cmds.empty?
  puts "Nothing to do for #{namespace}."
  exit 0
else
  puts "Cleaning up branches for #{namespace}.\n"
end

cmds.each{|cmd| puts "\n\033[33m#{cmd}\033[0m"; system cmd unless ARGV.include?('--dry-run')}
