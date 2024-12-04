# Generated by Django 5.1.3 on 2024-12-04 05:41

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_stock'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.RenameField(
            model_name='stock',
            old_name='ticker',
            new_name='symbol',
        ),
        migrations.RemoveField(
            model_name='stock',
            name='country',
        ),
        migrations.RemoveField(
            model_name='stock',
            name='industry',
        ),
        migrations.RemoveField(
            model_name='stock',
            name='ipo_year',
        ),
        migrations.RemoveField(
            model_name='stock',
            name='last_price',
        ),
        migrations.RemoveField(
            model_name='stock',
            name='marketcap',
        ),
        migrations.RemoveField(
            model_name='stock',
            name='net_change',
        ),
        migrations.RemoveField(
            model_name='stock',
            name='pct_change',
        ),
        migrations.RemoveField(
            model_name='stock',
            name='sector',
        ),
        migrations.RemoveField(
            model_name='stock',
            name='volume',
        ),
        migrations.AddField(
            model_name='stock',
            name='change',
            field=models.DecimalField(blank=True, decimal_places=2, max_digits=6, null=True),
        ),
        migrations.AddField(
            model_name='stock',
            name='last_updated',
            field=models.DateTimeField(auto_now=True),
        ),
        migrations.AddField(
            model_name='stock',
            name='market_cap',
            field=models.BigIntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='stock',
            name='price',
            field=models.DecimalField(blank=True, decimal_places=2, max_digits=10, null=True),
        ),
        migrations.AddField(
            model_name='stock',
            name='revenue',
            field=models.BigIntegerField(blank=True, null=True),
        ),
        migrations.AlterField(
            model_name='stock',
            name='name',
            field=models.CharField(max_length=255),
        ),
        migrations.CreateModel(
            name='Portfolio',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ticker', models.CharField(max_length=10)),
                ('shares', models.FloatField()),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='portfolio', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Favorite',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('ticker', models.CharField(max_length=10)),
                ('name', models.CharField(max_length=100)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='favorites', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'unique_together': {('user', 'ticker')},
            },
        ),
    ]