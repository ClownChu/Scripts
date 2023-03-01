<h1 align="center">ClownChu Scripts</h1>
<h3 align="center">Collection of *<b><i><small>maybe</small></i></b>* helpful scripts</h3>

<br />

<h1 id="getting_started">
    Getting Started
</h2>
<ul>
    <li>
        Clone repostory
    </li>
    <ul>
        <li><code>git clone https://github.com/ClownChu/Scripts ~/ClownChu/Scripts</code></li>
    </ul>
    <li>
        File permissions (for cron execution)
    </li>
    <ul>
        <li><code>chmod -R 700 ~/ClownChu/Scripts</code></li>
        <li><code>chown -R root.root ~/ClownChu/Scripts</code></li>
    </ul>
    <li>
        Cron job setup:
    </li>
    <ul>
        <li><code>crontab -e</code></li>
        <li>
            Add text to end of the file to execute every day at 1:30AM
            <br /> 
            <code>30 1 * * * ~/ClownChu/Scripts/{SCRIPT_PATH} {SCRIPT_PARAMETERS} 2>&1 > {EXECUTION_OUTPUT_PATH}</code>
        </li>
    </ul>
</ul>

<h1 id="summary">
    Scripts Summary
</h1>

<table align="center">
    <thead>
        <tr>
            <th colspan="2">
                <div align="center">
                    <a href="/bash" style="font-size: 40px;">
                        <img src="https://th.bing.com/th/id/OIP.9hBO-8N0zl7ijPab6dhjxQHaHY?pid=ImgDet&rs=1" alt="Bash" width="35px" height="35px" />
                        Bash
                    </a>
                </div>
            </th>
        </tr>
        <tr>
            <th>
                Name
            </th>
            <th>
                <div align="center">Description</div>
            </th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>
                <a href="/bash/linux_backup" target="_blank" id="linux_backup_sh">linux_backup.sh</a>
            </td>
            <td>
                <div align="center">
                    Manages system backups and sync backed up files with <a href="https://rclone.org/" target="_blank">rClone</a>
                </div>
            </td>
        </tr>
    </tbody>
</table>

<br />
<hr>

<h2 align="center" id="license">License</h2>
<div align="center">
    <a href="https://github.com/ClownChu/Scripts" target="_blank">ClownChu Scripts</a> is made available under the <a href="https://www.gnu.org/licenses/agpl-3.0.en.html" target="_blank">GNU Affero General Public License v3.0</a> license. (<a href="https://choosealicense.com/licenses/agpl-3.0/" target="_blank">Read more</a>)
</div>
