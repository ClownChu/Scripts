<h1 align="center">ClownChu Scripts</h1>
<h3 align="center">Collection of *<b><i><small>maybe</small></i></b>* helpful scripts</h3>

<small>
    <a href="https://github.com/ClownChu/Scripts">ClownChu/Scripts</a> > 
    <a href="/bash">bash</a> >
    <a href="/bash/linux_backup">linux_backup</a>
</small>

<br />

<h1 align="center" id="linux_backup_sh">
    linux_backup.sh
</h1>
<h3 align="center">
    Manages system backups and sync backed up files with <a href="https://rclone.org/" target="_blank">rClone</a>
</h3>

<h1 id="parameters">
    Parameters
</h1>
<ul>
    <li><b>DB_PASSWORD</b> - root user password to access MySQL DB</li>
    <li><b>BACKUP_PATH</b> - backup files output path</li>
    <li><b>FULL_BACKUP_DAY</b> - week day to execute full backups (<code>mon = 1; sun = 7</code>)</li>
    <li><b>MAX_BACKUPS</b> - number of backups to be maintained in the output folder</li>
    <li><b>RCLONE_REMOTE_NAME</b> - rClone remote name for <code>rclone sync</code> command (<code>''</code> to disable rClone sync)</li>
    <li><b>RCLONE_REMOTE_CONTAINER</b> - rClone remote container path for <code>rclone sync</code> command</li>
    <li><b>VERBOSE</b> - verbose mode (<code>true|false</code>)
</ul>

<h1 id="getting_started">
    Getting Started
</h1>
<ul>
    <li><code>sudo su</code></li>
    <li>
        (if not <code>root@localhost</code>) Configure <code>.my.cnf</code>
    </li>
    <ul>
        <li><code>nano ./.my.cnf</code></li>
        <li>
            Add text to end of the file: 
            <br />
            <code>[mysqldump]</code><br />
            <code>host=localhost</code><br />
            <code>user=root</code>
        </li>
    </ul>
    <li>
        Execution
    </li>
    <ul>
        <li>
            Manual execution:
        </li>
        <ul>
            <li><code>sh ~/ClownChu/Scripts/bash/linux_backup/linux_backup.sh '{DB_PASSWORD}' '{BACKUP_PATH}' {FULL_BACKUP_DAY} {MAX_BACKUPS} '{RCLONE_REMOTE_NAME}' '{RCLONE_REMOTE_CONTAINER}' '{VERBOSE}'</code></li>
        </ul>
    </ul>
</ul>

<br />
<hr>

<h2 align="center" id="license">License</h2>
<div align="center">
    <a href="https://github.com/ClownChu/Scripts" target="_blank">ClownChu Scripts</a> is made available under the <a href="https://www.gnu.org/licenses/agpl-3.0.en.html" target="_blank">GNU Affero General Public License v3.0</a> license. (<a href="https://choosealicense.com/licenses/agpl-3.0/" target="_blank">Read more</a>)
</div>
